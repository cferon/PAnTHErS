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
from tkinter import ttk

from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler

attach("../builder.sage")
attach("../Calibration/calibration.sage")

builder = Builder()

def setPlaintextsAppliTOREPLACE() :
    plaintexts = []
    #TO COMPLETE
    #MUST RETURN INPUT PARAMETERS OF THE APPLICATION
    return plaintexts

def createSchemeWithPlaintextsAppliTOREPLACE(scheme, params, sets, plaintexts, whichAnalysis) :

    schemeObject = createSchemeObject(scheme, params, sets, whichAnalysis)
    [R,_,_] = sets

    mes = []
    for i in range(len(plaintexts)) :
        mes.append(builder.message("m" + str(i), "plain", "poly", R(plaintexts[i]),1,1,0,0))

    return schemeObject, mes

def computeApplicationTOREPLACE(scheme, plaintexts, R, progressBar = 0, step = 0) :

    typeCipher = "NoType"
    if isinstance(scheme, FV12) or isinstance(scheme, FV12Complexity) or isinstance(scheme, FV12Memory) :
        typeCipher = "poly"
    if isinstance(scheme, YASHE) or isinstance(scheme, YASHEComplexity) or isinstance(scheme, YASHEMemory) :
        typeCipher = "poly"
    if isinstance(scheme, FNTRU) or isinstance(scheme, FNTRUComplexity) or isinstance(scheme, FNTRUMemory) :
        typeCipher = "matrixPoly"

    def XOR(mes1, mes2) :
        add = scheme.heAdd.ope([mes1,mes2], ["Add"])[0]
        return add

    def AND(mes1, mes2) :
        mult = scheme.heMult.ope([mes1,mes2], ["Mult"])[0]
        if progressBar != 0 and paramProgress != 0 :
            progressBar.updateProgress(paramProgress)
        return mult

    def NOT(mes1) :
        R = PolynomialRing(ZZ, names=('z',)); (z,) = R._first_ngens(1)
        un = builder.message("un", "plain", typeCipher, R(1),1,1,0,0)
        [un] = scheme.heEnc.ope([un], [un])
        xorRes = XOR(mes1, un)
        return xorRes

    def OR(mes1, mes2) :
        orRes = XOR(XOR(mes1, mes2), AND(mes1, mes2))
        return orRes

    def ENC(mes1, mes2) :
        enc = scheme.heEnc.ope([mes1], [mes2])[0]
        return enc

    def DEC(mes1, mes2) :
        dec = scheme.heDec.ope([mes1], [mes2])[0]
        return dec

    def MESSAGE(name, group, type, value, row, col, depth, deg) :
        mes = builder.message(name, group, type, value, row, col, depth, deg)
        return mes

    def KEYGEN() :
        scheme.heKeyGen.ope()

    R2 = PolynomialRing(ZZ.quo(2*ZZ), names=('y',)); (y,) = R2._first_ngens(1)

    KEYGEN()

    ["""List of input plaintexts"""] = plaintexts

    #PASTE YOUR APPLICATION CODE HERE

    return

def appliTOREPLACE(execOrAnalyse, scheme, params, progressBar) :
    paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]

    schemeName = findSchemeName(scheme)

    graphsName = []

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

            fileName = params[i].generateFileName(execOrAnalyse, "appli_name_"+schemeName, paramsCopy)
            file = open(fileName + ".csv", "w")
            file.write(params[i].name + "\t")
            file.write(axeName[1])
            file.write("\n")
            graphsName = graphsName + [fileName]

            progressBar.findPrefixeProgressBarLabel(scheme, paramsCopy)
            calibratedPoints = []

            if execOrAnalyse == EXECUTION_ID :#execution
                calibratedPoints = executeAppliTOREPLACE(scheme, paramsCopy, file, progressBar)
            elif execOrAnalyse == COMPLEXITY_ANALYSIS_ID or execOrAnalyse == MEMORY_ANALYSIS_ID : #analyse
                points = analyzeAppliTOREPLACE(scheme, paramsCopy, execOrAnalyse, file, progressBar)
                file.close()

                print("Analysis of complexity ({}): done".format(params[i].name))
                print("Starting calibration")

                practicalPoints, pracTime = getTOREPLACE2PracticalValues(execOrAnalyse, scheme, fileName, paramsCopy, points, progressBar)

                progressBar.configure("2-calibration: conversion")
                calibreTime1 = time.time()
                calibratedPoints = calibrate(practicalPoints, points)
                calibreTime2 = time.time()
                progressBar.updateProgress(100)

                pracFile = open("Res/calibrated_"+ fileName + ".csv", "w")
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

def analyzeAppliTOREPLACE(scheme, paramsIn, whichAnalysis, file, progressBar) :
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

        pointsList = panthersAppliTOREPLACEOnce(scheme, paramsIn, whichAnalysis, file, pointsList) #analyse

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliTOREPLACE(scheme, paramsIn, file, progressBar) :
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

        pointsList = executeAppliTOREPLACEOnce(scheme, paramsIn, progressBar, 100/float(nbOfSteps), file, pointsList) #execute

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliTOREPLACEOnce(scheme, paramsIn, progressBar = 0, step = 0, file = 0, pointsList = 0) :
    practicalAnalysis = executePracticalAnalysis(APPNUMBER_ID, EXECUTION_ID, "Practical_executeAppliTOREPLACEOnce", scheme, paramsIn, progressBar)

    if pointsList != 0 :
        for param in paramsIn :
            if not(param.isFixed) :
                pointsList = pointsList + [(param.currentValue,practicalAnalysis)]
                file.write(str(param.currentValue) + "\t" + str(practicalAnalysis) + "\n")
        return pointsList
    else :
        raise Exception("executeAppliTOREPLACEOnce: pointsList must be != 0.")

def panthersAppliTOREPLACEOnce(scheme, paramsIn, whichAnalysis, file, pointsList) :
    param, sets = chooseParameter(scheme, paramsIn)
    schemeObject, mes = createSchemeWithPlaintextsAppliTOREPLACE(scheme, param, sets, whichAnalysis)
    res = computeApplicationTOREPLACE(schemeObject, mes, sets[0])
    analysis = 0
    if whichAnalysis == COMPLEXITY_ANALYSIS_ID :
        analysis = schemeObject.globalComplexity()
    elif whichAnalysis == MEMORY_ANALYSIS_ID :
        logq = 0
        for param in paramsIn :
            if param.name == "log(q)" :
                logq = param.currentValue
        q = 2^logq
        analysis = schemeObject.globalMemory(q, "Atom", 32)
    else :
        raise Exception("panthersAppliTOREPLACEOnce: schemeObject is not a HESchemeComplexity or a HESchemeMemory but a {}".format(type(schemeObject)))

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

def getTOREPLACE2PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1= executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis2)]

    return practicalValues

def getTOREPLACE3PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []

    #1st execution
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    #2nd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = (params[j].min + params[j].max)/2

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [((params[j].min + params[j].max)/2, practicalAnalysis2)]

    #3rd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (3nd execution)")
    practicalAnalysis3 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_3_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis3)]

    return practicalValues

def getTOREPLACE4PracticalValues(whichAnalysis, scheme, fileName, params, points, progressBar) :
    practicalValues = []
    #1st execution
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_1_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    #2nd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].min +  floor((params[j].max - params[j].min)/3)

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_2_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min +  floor((params[j].min + params[j].max)/3), practicalAnalysis2)]

    #3rd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].min + floor(2*(params[j].max - params[j].min)/3)

    progressBar.configure("2-calibration (3rd execution)")
    practicalAnalysis3 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_3_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min + floor(2*(params[j].max - params[j].min)/3), practicalAnalysis3)]

    #4th execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (4th execution)")
    practicalAnalysis4 = executePracticalAnalysis(APPNUMBER_ID, whichAnalysis, "Practical_4_"+fileName, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis4)]

    return practicalValues
