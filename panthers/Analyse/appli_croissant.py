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

attach("~/panthers/builder.sage")
attach("~/panthers/Calibration/calibration.sage")

builder = Builder()

def setPlaintextsAppliCroissant(nbOfCroissant) :
    res = Integer(nbOfCroissant).digits(2, padto = 8)
    res.reverse()
    return res

def createSchemeWithPlaintextsAppliCroissant(scheme, params, sets, plaintexts, whichAnalysis) :

    schemeObject = createSchemeObject(scheme, params, sets, whichAnalysis)
    [R,_,_] = sets

    mes = []
    for i in range(len(plaintexts)) :
        mes.append(builder.message("m" + str(i), "plain", "poly", R(plaintexts[i]),1,1,0,0))

    return schemeObject, mes

def computeApplicationCroissant(scheme, plaintexts, R, progressBar = 0, step = 0) :
    nbOfOperations = 80.0
    nbOfMult = 106.0
    if step == 0 :
        step = 100

    paramProgress = step / nbOfMult

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

    [i_2_input, i_3_input, i_4_input, i_5_input, i_6_input, i_7_input, i_8_input, i_9_input] = plaintexts

    KEYGEN()
    i_2 = ENC(i_2_input, "i_2_input")
    i_3 = ENC(i_3_input, "i_3_input")
    i_4 = ENC(i_4_input, "i_4_input")
    i_5 = ENC(i_5_input, "i_5_input")
    i_6 = ENC(i_6_input, "i_6_input")
    i_7 = ENC(i_7_input, "i_7_input")
    i_8 = ENC(i_8_input, "i_8_input")
    i_9 = ENC(i_9_input, "i_9_input")

    m_6 = XOR(i_9, i_8)
    n106 = NOT(i_9)
    n104 = NOT(i_8)
    n20 = AND(i_9, i_8)
    n22 = NOT(i_7)
    m_7 = i_9
    n40 = NOT(i_5)
    n19 = NOT(i_3)
    n17 = NOT(i_6)
    n18 = NOT(i_4)
    n25 = XOR(n20, i_8)
    n23 = XOR(n20, n22)
    n21 = NOT(n20)
    n51 = XOR(n23, i_8)
    n24 = NOT(n23)
    m_5 = XOR(n51, n106)
    n26 = AND(n25, n24)
    n52 = NOT(n51)
    n27 = XOR(n26, n21)
    n53 = AND(n52, i_9)
    n54 = NOT(n53)
    n58 = XOR(n53, i_8)
    n28 = XOR(n27, i_6)
    n30 = XOR(n27, n22)
    n29 = NOT(n28)
    n55 = XOR(n28, i_7)
    n56 = XOR(n55, n53)
    n31 = AND(n30, n29)
    n57 = NOT(n56)
    m_4 = XOR(n56, n104)
    n32 = XOR(n31, n27)
    n35 = XOR(n32, n17)
    n33 = XOR(n32, i_5)
    n59 = AND(n58, n57)
    n60 = XOR(n59, n54)
    n62 = XOR(n33, i_6)
    n34 = NOT(n33)
    n65 = XOR(n60, n22)
    n61 = NOT(n60)
    n36 = AND(n35, n34)
    n63 = XOR(n62, n61)
    n37 = XOR(n36, n32)
    n84 = XOR(n63, i_7)
    n64 = NOT(n63)
    n38 = XOR(n37, i_4)
    n41 = XOR(n37, n40)
    n66 = AND(n65, n64)
    n69 = XOR(n38, i_5)
    n85 = NOT(n84)
    n39 = NOT(n38)
    m_3 = XOR(n84, n106)
    n42 = AND(n41, n39)
    n67 = XOR(n66, n60)
    n86 = AND(n85, i_9)
    n72 = XOR(n67, n17)
    n91 = XOR(n86, i_8)
    n68 = NOT(n67)
    n43 = XOR(n42, n37)
    n87 = NOT(n86)
    n70 = XOR(n69, n68)
    n44 = XOR(n43, i_3)
    n46 = XOR(n43, n18)
    n45 = NOT(n44)
    n76 = XOR(n44, i_4)
    n71 = NOT(n70)
    n88 = XOR(n70, i_6)
    n47 = AND(n46, n45)
    n73 = AND(n72, n71)
    n89 = XOR(n88, n86)
    n90 = NOT(n89)
    n48 = XOR(n47, n43)
    n74 = XOR(n73, n67)
    m_2 = XOR(n89, n104)
    n75 = NOT(n74)
    n79 = XOR(n74, n40)
    n92 = AND(n91, n90)
    n49 = XOR(n48, i_2)
    n50 = XOR(n49, n19)
    n77 = XOR(n76, n75)
    n93 = XOR(n92, n87)
    n98 = XOR(n93, n22)
    n95 = XOR(n77, i_5)
    n78 = NOT(n77)
    n94 = NOT(n93)
    n80 = AND(n79, n78)
    n96 = XOR(n95, n94)
    n97 = NOT(n96)
    n81 = XOR(n80, n74)
    m_1 = XOR(n96, n22)
    n82 = XOR(n81, n50)
    n99 = AND(n98, n97)
    n83 = XOR(n82, n18)
    n100 = XOR(n99, n93)
    n101 = XOR(n100, n83)
    m_0 = XOR(n101, n17)

    m_0_output = DEC(m_0, "m_0_output")
    m_1_output = DEC(m_1, "m_1_output")
    m_2_output = DEC(m_2, "m_2_output")
    m_3_output = DEC(m_3, "m_3_output")
    m_4_output = DEC(m_4, "m_4_output")
    m_5_output = DEC(m_5, "m_5_output")
    m_6_output = DEC(m_6, "m_6_output")
    m_7_output = DEC(m_7, "m_7_output")

    res = (int(R2(m_0_output.value))*128 + int(R2(m_1_output.value))*64 + int(R2(m_2_output.value))*32 + int(R2(m_3_output.value))*16 + int(R2(m_4_output.value))*8 + int(R2(m_5_output.value))*4 + int(R2(m_6_output.value))*2 + int(R2(m_7_output.value)))*10

    return res

def appliCroissant(execOrAnalyse, scheme, params, progressBar) :
    paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]

    graphsCroissant = []

    schemeCroissant = getSchemeName(scheme)

    for i in range(len(params)) :
        if not(params[i].isFixed) :
            print("Starting analysis of complexity with {} parameter variation".format(params[i].name))
            axeCroissant = [params[i].name]
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
            axeCroissant = axeCroissant + [paramsFixed]

            fileCroissant = params[i].generateFileName(execOrAnalyse, "appli_croissant_"+schemeCroissant, paramsCopy)
            file = open("Res/" + fileCroissant + ".csv", "w")
            file.write(params[i].name + "\t")
            file.write(axeCroissant[1])
            file.write("\n")
            graphsCroissant = graphsCroissant + [fileCroissant]

            progressBar.findPrefixeProgressBarLabel(scheme, paramsCopy)
            calibratedPoints = []

            if execOrAnalyse == EXECUTION_ID :#execution
                calibratedPoints = executeAppliCroissant(scheme, paramsCopy, file, progressBar)
            elif execOrAnalyse == COMPLEXITY_ANALYSIS_ID or execOrAnalyse == MEMORY_ANALYSIS_ID : #analyse
                points = analyzeAppliCroissant(scheme, paramsCopy, execOrAnalyse, file, progressBar)
                file.close()

                print("Analysis of complexity ({}): done".format(params[i].name))
                print("Starting calibration")

                practicalPoints = getCroissant2PracticalValues(execOrAnalyse, scheme, fileCroissant, paramsCopy, points, progressBar)

                progressBar.configure("2-calibration: conversion")
                calibreTime1 = time.time()
                calibratedPoints = calibrate(practicalPoints, points)
                calibreTime2 = time.time()
                progressBar.updateProgress(100)

                pracFile = open("Res/calibrated_"+fileCroissant + ".csv", "w")
                for iParam in range(len(calibratedPoints)) :
                    pracFile.write(str(calibratedPoints[iParam][0]) + "\t" + str(calibratedPoints[iParam][1]) + "\n")
                pracFile.close()

                for param in params :
                    param.currentValue = 0

                print("Calibration: done")
            print("Starting graph generation")

            progressBar.configure("Graph generation")
            generateGraph(axeCroissant, calibratedPoints, fileCroissant)
            progressBar.updateProgress(100)

            print("Graph {} generated".format(fileCroissant))

    return graphsCroissant

def analyzeAppliCroissant(scheme, paramsIn, whichAnalysis, file, progressBar) :
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

        pointsList = panthersAppliCroissantOnce(scheme, paramsIn, whichAnalysis, file, pointsList) #analyse

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliCroissant(scheme, paramsIn, file, progressBar) :
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

        pointsList = executeAppliCroissantOnce(scheme, paramsIn, progressBar, 100/float(nbOfSteps), file, pointsList) #execute

        for param in paramsIn :
            param.getNextParamVariationValue()

        isTerminated = False
        for param in paramsIn :
            isTerminated = isTerminated or param.isMaxValueReached()
        progressBar.updateProgress(100 / float(nbOfSteps))

    for param in paramsIn :
        param.currentValue = 0

    return pointsList

def executeAppliCroissantOnce(scheme, paramsIn, progressBar = 0, step = 0, file = 0, pointsList = 0) :
    practicalAnalysis = executePracticalAnalysis(CROISSANT_ID, EXECUTION_ID, "Practical_executeAppliCroissantOnce", scheme, paramsIn, progressBar)

    if pointsList != 0 :
        for param in paramsIn :
            if not(param.isFixed) :
                pointsList = pointsList + [(param.currentValue,practicalAnalysis)]
                file.write(str(param.currentValue) + "\t" + str(practicalAnalysis) + "\n")
        return pointsList
    else :
        raise Exception("executeAppliCroissantOnce: pointsList must be != 0.")

def panthersAppliCroissantOnce(scheme, paramsIn, whichAnalysis, file, pointsList) :
    param, sets = chooseParameter(scheme, paramsIn)
    plain = setPlaintextsAppliCroissant(2)
    schemeObject, mes = createSchemeWithPlaintextsAppliCroissant(scheme, param, sets, plain, whichAnalysis)
    res = computeApplicationCroissant(schemeObject, mes, sets[0])
    analysis = 0
    if whichAnalysis == COMPLEXITY_ANALYSIS_ID :
        analysis = schemeObject.globalComplexity()
    elif whichAnalysis == MEMORY_ANALYSIS_ID :
        q = schemeObject.q.value
        analysis = schemeObject.globalMemory(q, "Atom", 32)
    else :
        raise Exception("panthersAppliCroissantOnce: schemeObject is not a HESchemeComplexity or a HESchemeMemory but a {}".format(type(schemeObject)))

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

def getCroissant2PracticalValues(whichAnalysis, scheme, fileCroissant, params, points, progressBar) :
    practicalValues = []
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_1_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_2_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis2)]

    return practicalValues

def getCroissant3PracticalValues(whichAnalysis, scheme, fileCroissant, params, points, progressBar) :
    practicalValues = []

    #1st execution
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_1_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    #2nd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = (params[j].min + params[j].max)/2

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_2_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [((params[j].min + params[j].max)/2, practicalAnalysis2)]

    #3rd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (3nd execution)")
    practicalAnalysis3 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_3_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis3)]

    return practicalValues

def getCroissant4PracticalValues(whichAnalysis, scheme, fileCroissant, params, points, progressBar) :
    practicalValues = []
    #1st execution
    for j in range(len(params)) :
        if params[j].isFixed :
            params[j].currentValue = params[j].default
        else :
            params[j].currentValue = params[j].min

    progressBar.configure("2-calibration (1st execution)")
    practicalAnalysis1 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_1_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min, practicalAnalysis1)]

    #2nd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].min +  floor((params[j].max - params[j].min)/3)

    progressBar.configure("2-calibration (2nd execution)")
    practicalAnalysis2 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_2_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min +  floor((params[j].min + params[j].max)/3), practicalAnalysis2)]

    #3rd execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].min + floor(2*(params[j].max - params[j].min)/3)

    progressBar.configure("2-calibration (3rd execution)")
    practicalAnalysis3 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_3_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].min + floor(2*(params[j].max - params[j].min)/3), practicalAnalysis3)]

    #4th execution
    for j in range(len(params)) :
        if not(params[j].isFixed) :
            params[j].currentValue = params[j].max

    progressBar.configure("2-calibration (4th execution)")
    practicalAnalysis4 = executePracticalAnalysis(CROISSANT_ID, whichAnalysis, "Practical_4_"+fileCroissant, scheme, params, progressBar)

    for j in range(len(params)) :
        if not(params[j].isFixed) :
            practicalValues = practicalValues + [(params[j].max, practicalAnalysis4)]

    return practicalValues
