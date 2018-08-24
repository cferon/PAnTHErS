#
# (C) Copyright 2018 - Cyrielle FERON / ENSTA Bretagne.
# Contributor(s) : Cyrielle FERON <cyrielle.feron@ensta-bretagne.org> (2018)
#
#
# This software is governed by the CeCILL 2.1 license under French law and
# abiding by the rules of distribution of free software.  You can  use,
# modify and/ or redistribute the software under the terms of the CeCILL 2.1
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and,  more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL 2.1 license and that you accept its terms.
#
#


import time
import psutil
import ttk

from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler

attach("../builder.sage")
attach("../Calibration/calibration.sage")

builder = Builder()

def createSchemeWithPlaintextsAppliFiveHB(scheme, params, sets, whichAnalysis) :

    schemeObject = createSchemeObject(scheme, params, sets, whichAnalysis)
    [R,_,_] = sets
    d = schemeObject.d.value
    mes = builder.message("m", "plain", "poly", R.random_element(degree=d-1),1,1,0,d-1)

    return schemeObject, mes

def computeApplicationFiveHB(scheme, plaintexts, R, progressBar = 0, step = 0) :
    scheme.heKeyGen.ope()
    [mEncrypt] = scheme.heEnc.ope([plaintexts], ["mEncrypt"])
    [mAddn] = scheme.heAdd.ope([mEncrypt,mEncrypt], ["mAddm"])
    [mMultn] = scheme.heMult.ope([mAddn, mEncrypt], ["mMultm"])
    [mMultnDecrypted] = scheme.heDec.ope([mMultn], ["mAddmDecrypted"])
    return mMultnDecrypted

def appliFiveHB(execOrAnalyse, scheme, params, progressBar) :
    paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]

    graphsName = []

    schemeName = getSchemeName(scheme)

    for i in range(len(params)) :
        if not(params[i].isFixed) :
            print("Starting analysis of complexity with {} parameter variation".format(params[i].name))
            axeName = [params[i].name]
            paramsFixed = ""
            if execOrAnalyse == COMPLEXITY_ANALYSIS_ID :
                paramsFixed = "Time "
            elif execOrAnalyse == MEMORY_ANALYSIS_ID :
                paramsFixed = "MiB "
            paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]
            for j in range(len(paramsCopy)) :
                if i != j :
                    paramsCopy[j].isFixed = True
                    paramsFixed = paramsFixed + "\n" + paramsCopy[j].name + "=" + str(paramsCopy[j].default) + " "
            axeName = axeName + [paramsFixed]

            fileName = params[i].generateFileName(execOrAnalyse, "appli_fiveHB_"+schemeName, paramsCopy)
            file = open("Res/" + fileName + ".csv", "w", 0)
            file.write(params[i].name + "\t")
            file.write(axeName[1])
            file.write("\n")
            graphsName = graphsName + [fileName]

            progressBar.findPrefixeProgressBarLabel(scheme, paramsCopy)
            calibratedPoints = []

            if execOrAnalyse == EXECUTION_ID : #execution
                calibratedPoints = executeAppliFiveHB(scheme, paramsCopy, file, progressBar)
            elif execOrAnalyse == COMPLEXITY_ANALYSIS_ID or execOrAnalyse == MEMORY_ANALYSIS_ID : #analyse
                points = analyzeAppliFiveHB(scheme, paramsCopy, execOrAnalyse, file, progressBar)
                file.close()

                print("Analysis of complexity ({}): done".format(params[i].name))
                print("Starting calibration")

                practicalPoints = getFiveHB2PracticalValues(execOrAnalyse, scheme, fileName, paramsCopy, points, progressBar)

                progressBar.configure("2-calibration: conversion")
                calibreTime1 = time.time()
                calibratedPoints = calibrate(practicalPoints, points)
                calibreTime2 = time.time()
                progressBar.updateProgress(100)

                pracFile = open("Res/calibrated_"+fileName + ".csv", "w")
                for iParam in range(len(calibratedPoints)) :
                    pracFile.write(str(calibratedPoints[iParam][0]) + "\t" + str(calibratedPoints[iParam][1]) + "\n")
                pracFile.close()

                for param in params :
                    param.currentValue = 0

                print("Calibration: done")
            print("Starting graph generation")

            progressBar.configure("Graph generation")
            generateGraph(axeName, calibratedPoints, fileName)
            progressBar.updateProgress(100)

            print("Graph {} generated".format(fileName))

    return graphsName

def analyzeAppliFiveHB(scheme, paramsIn, whichAnalysis, file, progressBar) :
    progressBar.configure("analysis")

    nbOfSteps = 0
    for param in paramsIn :
        if not(param.isFixed) :
            nbOfSteps = ceil((param.max - param.min + 1)/ float(param.step))

    for param in paramsIn :
        param.getInitParamVariationValue()

    isTerminated = False
    for param in paramsIn :
        isTerminated = isTerminated or param.isMaxValueReached()

    pointsList = []

    while not(isTerminated) :
        textToPrint = ""
        for param in paramsIn :
            textToPrint = textToPrint + "{} = {} ".format(param.name, param.currentValue)
        print(textToPrint)

        pointsList = panthersAppliFiveHBOnce(scheme, paramsIn, whichAnalysis, file, pointsList) #analyse

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliFiveHB(scheme, paramsIn, file, progressBar) :
    progressBar.configure("execution")

    nbOfSteps = 0
    for param in paramsIn :
        if not(param.isFixed) :
            nbOfSteps = ceil((param.max - param.min + 1)/ float(param.step))

    for param in paramsIn :
        param.getInitParamVariationValue()

    isTerminated = False
    for param in paramsIn :
        isTerminated = isTerminated or param.isMaxValueReached()

    pointsList = []

    while not(isTerminated) :
        textToPrint = ""
        for param in paramsIn :
            textToPrint = textToPrint + "{} = {} ".format(param.name, param.currentValue)
        print(textToPrint)

        pointsList = executeAppliFiveHBOnce(scheme, paramsIn, progressBar, 100/float(nbOfSteps), file, pointsList) #execute

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliFiveHBOnce(scheme, paramsIn, progressBar = 0, step = 0, file = 0, pointsList = 0) :
    practicalAnalysisMem, practicalAnalysisComp = executePracticalAnalysis(FIVEHB_ID, EXECUTION_ID, "Practical_executeAppliFiveHBOnce", scheme, paramsIn, progressBar)

    if pointsList != 0 :
        for param in paramsIn :
            if not(param.isFixed) :
                pointsList = pointsList + [(param.currentValue,practicalAnalysisComp)]
                print(scheme, param.currentValue, practicalAnalysisComp, practicalAnalysisMem)
                file.write(str(param.currentValue) + "\t" + str(practicalAnalysisComp)+ "\t" + str(practicalAnalysisMem) + "\n")
        return pointsList
    else :
        raise Exception("executeAppliFiveHBOnce: pointsList must be != 0.")

def panthersAppliFiveHBOnce(scheme, paramsIn, whichAnalysis, file, pointsList) :
    param, sets = chooseParameter(scheme, paramsIn)
    schemeObject, mes = createSchemeWithPlaintextsAppliFiveHB(scheme, param, sets, whichAnalysis)
    res = computeApplicationFiveHB(schemeObject, mes, sets[0])
    analysis = 0
    if whichAnalysis == COMPLEXITY_ANALYSIS_ID :
        analysis = schemeObject.globalComplexity()
    elif whichAnalysis == MEMORY_ANALYSIS_ID :
        q = schemeObject.q.value
        analysis = schemeObject.globalMemory(q, "Atom", 32)
    else :
        raise Exception("panthersAppliFiveHBOnce: schemeObject is not a HESchemeComplexity or a HESchemeMemory but a {}".format(type(schemeObject)))

    isOneParamFixed = False
    for param in paramsIn :
        if not(param.isFixed) :
            isOneParamFixed = True
            pointsList = pointsList + [(param.currentValue,analysis)]
            file.write(str(param.currentValue) + "\t" + str(analysis) + "\n")
    if isOneParamFixed == False :
        params = []
        if not(isinstance(pointsList, list)) :
            file.write(str(pointsList)+"\t")
            for i in range(len(paramsIn)) :
                params = params + [paramsIn[i].currentValue]
                file.write(str(paramsIn[i].currentValue) + "\t")
            file.write(str(analysis) + "\n")
        return analysis

    return pointsList

def getFiveHB2PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis2)]

    return practicalValues

def getFiveHB3PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []

    #1st execution
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    #2nd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = (params[j].min + params[j].max)/2

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [((params[j].min + params[j].max)/2, practicalAnalysis2)]

    #3rd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (3nd execution)")
    practicalAnalysis3 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_3_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis3)]

    return practicalValues

def getFiveHB4PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []
    #1st execution
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    #2nd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].min +  floor((params[j].max - params[j].min)/3)

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min +  floor((params[j].min + params[j].max)/3), practicalAnalysis2)]

    #3rd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].min + floor(2*(params[j].max - params[j].min)/3)

    progressBar.configure("2-calibration (3rd execution)")
    practicalAnalysis3 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_3_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min + floor(2*(params[j].max - params[j].min)/3), practicalAnalysis3)]

    #4th execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (4th execution)")
    practicalAnalysis4 = executePracticalAnalysis(FIVEHB_ID, whichAnalysis, "Practical_4_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis4)]

    return practicalValues
