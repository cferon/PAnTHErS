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
import os.path
from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler

attach("../homomorphicobject.sage")
attach("../parameter.sage")
attach("../key.sage")
attach("../hemessage.sage")
attach("../finder.sage")
attach("../builder.sage")
attach("../objectoperator.sage")
attach("../specificfunction.sage")
attach("../atomicfunction.sage")
attach("../atomicfunctioncreator.sage")
attach("../specificfunctioncreator.sage")
attach("../hebasicfunction.sage")
attach("../hedec.sage")
attach("../heenc.sage")
attach("../headd.sage")
attach("../hekeygen.sage")
attach("../hescheme.sage")
attach("../hemult.sage")
attach("../fv12.sage")
attach("../yashe.sage")
attach("../fntru.sage")

attach("../Complexity/complexity.sage")
attach("../Complexity/homomorphicobjectcomplexity.sage")
attach("../Complexity/objectoperatorcomplexity.sage")
attach("../Complexity/atomicfunctioncomplexity.sage")
attach("../Complexity/atomicfunctioncomplexitycreator.sage")
attach("../Complexity/specificfunctioncomplexity.sage")
attach("../Complexity/specificfunctioncomplexitycreator.sage")
attach("../Complexity/hebasicfunctioncomplexity.sage")
attach("../Complexity/hedeccomplexity.sage")
attach("../Complexity/heenccomplexity.sage")
attach("../Complexity/headdcomplexity.sage")
attach("../Complexity/hekeygencomplexity.sage")
attach("../Complexity/hemultcomplexity.sage")
attach("../Complexity/heschemecomplexity.sage")
attach("../Complexity/fv12complexity.sage")
attach("../Complexity/yashecomplexity.sage")
attach("../Complexity/fntrucomplexity.sage")

attach("../Memory/memory.sage")
attach("../Memory/homomorphicobjectmemory.sage")
attach("../Memory/objectoperatormemory.sage")
attach("../Memory/atomicfunctionmemory.sage")
attach("../Memory/atomicfunctionmemorycreator.sage")
attach("../Memory/specificfunctionmemory.sage")
attach("../Memory/specificfunctionmemorycreator.sage")
attach("../Memory/hebasicfunctionmemory.sage")
attach("../Memory/heencmemory.sage")
attach("../Memory/hedecmemory.sage")
attach("../Memory/headdmemory.sage")
attach("../Memory/hekeygenmemory.sage")
attach("../Memory/hemultmemory.sage")
attach("../Memory/heschemememory.sage")
attach("../Memory/fv12memory.sage")
attach("../Memory/yashememory.sage")
attach("../Memory/fntrumemory.sage")

attach("../Analyse/paramvariation.sage")
attach("../Analyse/paramanalyzed.sage")
attach("../Analyse/graphgeneration.sage")
attach("../Analyse/parameterschoice.sage")
attach("../Analyse/appli_med.py")
attach("../Analyse/appli_toy.py")
attach("../Analyse/appli_fiveHB.py")
attach("../Analyse/appli_croissant.py")

builder = Builder()

def bench(execOrAnalyze, appli, scheme, params, progressBar) :
    graphsName = []
    if appli == MEDICAL_ID :
        print("Medical Application")
        graphsName = appliMedical(execOrAnalyze, scheme, params, progressBar)
    elif appli == TOY_ID :
        print("Toy Application")
        graphsName = appliToy(execOrAnalyze, scheme, params, progressBar)
    elif appli == FIVEHB_ID :
        print("FiveHB Application")
        graphsName = appliFiveHB(execOrAnalyze, scheme, params, progressBar)
    elif appli == CROISSANT_ID :
        print("Croissant Application")
        graphsName = appliCroissant(execOrAnalyze, scheme, params, progressBar)
    return graphsName

def paramVariationCreator(scheme, valMinMax = 0) :
    """ valMinMax = [qMin,qMax, wMin,wMax, tMin,tMax]   for FV and YASHE
        valMinMax = [qMin,qMax, wMin,wMax]              for FNTRU
        valMinMax = 0 si min et max pas important"""

    if valMinMax == 0 :
        valMinMax = [2,2,2,2,2,2]

    q = ParamVariation("log(q)", valMinMax[0], valMinMax[1], 1, True, 1, valMinMax[0])
    schemeParams = [q]

    if scheme == FV_ID or scheme == YASHE_ID or scheme == FNTRU_ID :
        w = ParamVariation("log(w)", valMinMax[2], valMinMax[3], 1, True, 1, valMinMax[2])
        schemeParams = schemeParams + [w]

    if scheme == FV_ID or scheme == YASHE_ID :
        t = ParamVariation("t", valMinMax[4], valMinMax[5], 1, True, 1, valMinMax[4])
        schemeParams = schemeParams + [t]

    return schemeParams

def getDepthList(schemeName, depth) :
    paramList = []
    fileName = "../Analyse/DepthSets/depth_params_"+schemeName+ "_"+ str(depth)+".csv"

    if os.path.isfile(fileName) :
        file = open(fileName, "r")
        paramList = eval(file.read())
        file.close()
        for i in range(len(paramList)) :
            paramList[i] = ParamAnalyzed(paramList[i])
        return paramList
    else :
        return 0

def putDepthListInFile(schemeName, depth, paramList) :
    file = open("../Analyse/DepthSets/depth_params_"+schemeName+ "_"+ str(depth)+".csv", "w")
    file.write(str(paramList))
    file.close()

def findParamsForDepth(scheme, tabMinMax, depth, secu, progressBar) :
    if isinstance(depth, list) :
        depthMin = depth[0]
        depthMax = depth[1]
    elif isinstance(depth, int) or isinstance(depth, Integer) :
        depthMin = depth
        depthMax = depth + 1

    depths = {i for i in range(depthMin, depthMax)}
    depthsTmp = {i for i in range(depthMin, depthMax)}

    allParams = []
    newParams = []

    schemeName = getSchemeName(scheme)

    for i in depthsTmp :
        params = getDepthList(schemeName, i)
        if params != 0 and params != [] :
            allParams = allParams + getDepthList(schemeName, i)
            depths.remove(i)

    if scheme == FV_ID or scheme == YASHE_ID  :
        [qMin,qMax, tMin, wMax, wMin,tMax] = tabMinMax[scheme]
        valMinMax = [qMin,qMax, wMin, wMax, tMin,tMax]
    elif scheme == FNTRU_ID :
        valMinMax = tabMinMax[scheme]
    else :
        raise Exception("findParamsForDepth: scheme id {} is not available in PAnTHErS (> 2 or < 0)".format(scheme))

    schemeParams = paramVariationCreator(scheme, valMinMax)

    if depths != set() :
        depthMin = min(depths)
        paramsIn, sets = chooseParameter(scheme, schemeParams)
        schemeObject = createSchemeObject(scheme, paramsIn, sets, EXECUTION_ID)
        checkDepth = schemeObject.depth()

        while checkDepth < depthMin :
            schemeParams[0].currentValue = schemeParams[0].currentValue + 1
            paramsIn, sets = chooseParameter(scheme, schemeParams)
            schemeObject = createSchemeObject(scheme, paramsIn, sets, EXECUTION_ID)
            checkDepth = schemeObject.depth()

        schemeParams[0].min = schemeParams[0].currentValue

        if scheme == FV_ID or scheme == YASHE_ID :
            paramProgress = 33.0/(qMax - schemeParams[0].min + 1)
            progressBar.updateProgress(33)
            for indexQ in range(schemeParams[0].min, qMax) :
                print(indexQ, qMax)
                progressBar.updateProgress(paramProgress)
                schemeParams[0].currentValue = indexQ
                for indexW in range(schemeParams[2].min, wMax) :
                    if indexW < indexQ :
                        schemeParams[2].currentValue = indexW
                        paramsIn, sets = chooseParameter(scheme, schemeParams)
                        schemeObject = createSchemeObject(scheme, paramsIn, sets, EXECUTION_ID)
                        checkDepth = schemeObject.depth()
                        if checkDepth in depths :
                            newParams = newParams + [(checkDepth, [schemeParams[0].currentValue, schemeParams[1].currentValue, schemeParams[2].currentValue])]
                        elif checkDepth < depthMin :
                            break

        if scheme == FNTRU_ID :
            paramProgress = 50.0/(qMax - schemeParams[0].min + 1)
            progressBar.updateProgress(50)
            for indexQ in range(schemeParams[0].min, qMax) :
                progressBar.updateProgress(paramProgress)
                print(indexQ, qMax)
                schemeParams[0].currentValue = indexQ
                for indexW in range(schemeParams[1].min, wMax) :
                    if indexW < indexQ :
                        schemeParams[1].currentValue = indexW
                        paramsIn, sets = chooseParameter(scheme, schemeParams)
                        schemeObject = createSchemeObject(scheme, paramsIn, sets, EXECUTION_ID)
                        checkDepth = schemeObject.depth()
                        if checkDepth in depths :
                            newParams = newParams + [ParamAnalyzed(scheme=scheme, params = [schemeParams[0].currentValue, schemeParams[1].currentValue], depth=checkDepth)]
                        elif checkDepth < depthMin :
                            break

        if scheme == FV_ID or scheme == YASHE_ID : # FV & YASHE
            allParamsTmp = newParams
            newParams = []
            count = 1
            paramProgress = 33.0/len(allParamsTmp)
            for paramSet in allParamsTmp :
                progressBar.updateProgress(paramProgress)
                print(count, len(allParamsTmp))
                count = count + 1
                schemeParams[0].currentValue = paramSet[1][0]
                schemeParams[2].currentValue = paramSet[1][2]
                for indexT in range(tMin, tMax) :
                    schemeParams[1].currentValue = indexT
                    paramsIn, sets = chooseParameter(scheme, schemeParams)
                    schemeObject = createSchemeObject(scheme, paramsIn, sets, EXECUTION_ID)
                    checkDepth = schemeObject.depth()
                    if checkDepth in depths :
                        newParams = newParams + [ParamAnalyzed(scheme=scheme, params = [schemeParams[0].currentValue, indexT, schemeParams[2].currentValue], depth=checkDepth)]
                    elif checkDepth < depthMin :
                        break

        for i in depths :
            paramOfDepth = []
            for param in newParams :
                if param.depth == i :
                    paramOfDepth = paramOfDepth + [param]
            putDepthListInFile(schemeName, i, paramOfDepth)

    return allParams+newParams, schemeParams

def panthersAppli(appli, scheme, listParams, execOrAnalyze, fileComp, fileMem, progressBar = 0) :
    """execOrAnalyze: 0 (analyze), 1 (execution) """

    schemeParams = paramVariationCreator(scheme)
    nbOfSets = len(listParams)

    paramProgress = 100.0/nbOfSets

    for setParam in listParams :
        setParam.scheme = scheme
        setParam.appli = appli

        schemeParams[0].currentValue = setParam.params[0]
        paramName = "(" + str(setParam.params[0]) + ", "
        if scheme == FV_ID or scheme == YASHE_ID or scheme == FNTRU_ID :
            schemeParams[1].currentValue = setParam.params[1]
            paramName = paramName + str(setParam.params[1])
        if scheme == FV_ID or scheme == YASHE_ID :
            schemeParams[2].currentValue = setParam.params[2]
            paramName = paramName + ", " + str(setParam.params[2])

        if appli == MEDICAL_ID :
            setParam.compPanthers = panthersAppliMedicalOnce(scheme, schemeParams, COMPLEXITY_ANALYSIS_ID, fileComp, setParam.depth)
            setParam.memPanthers = panthersAppliMedicalOnce(scheme, schemeParams, MEMORY_ANALYSIS_ID, fileMem, setParam.depth)
            if execOrAnalyze == EXECUTION_ID :
                setParam.memCalibrated, setParam.compCalibrated = executePracticalAnalysis(appli, EXPLORATION_ID, "MiB_mem_tmp", scheme, schemeParams)

        elif appli == TOY_ID :
            setParam.compPanthers = panthersAppliToyOnce(scheme, schemeParams, COMPLEXITY_ANALYSIS_ID, fileComp, setParam.depth)
            setParam.memPanthers = panthersAppliToyOnce(scheme, schemeParams, MEMORY_ANALYSIS_ID, fileMem, setParam.depth)
            if execOrAnalyze == EXECUTION_ID :
                setParam.memCalibrated, setParam.compCalibrated = executePracticalAnalysis(appli, EXPLORATION_ID, "MiB_mem_tmp", scheme, schemeParams)

        elif appli == FIVEHB_ID :
            setParam.compPanthers = panthersAppliFiveHBOnce(scheme, schemeParams, COMPLEXITY_ANALYSIS_ID, fileComp, setParam.depth)
            setParam.memPanthers = panthersAppliFiveHBOnce(scheme, schemeParams, MEMORY_ANALYSIS_ID, fileMem, setParam.depth)
            if execOrAnalyze == EXECUTION_ID :
                setParam.memCalibrated, setParam.compCalibrated = executePracticalAnalysis(appli, EXPLORATION_ID, "MiB_mem_tmp", scheme, schemeParams)

        elif appli == CROISSANT_ID :
            setParam.compPanthers = panthersAppliCroissantOnce(scheme, schemeParams, COMPLEXITY_ANALYSIS_ID, fileComp, setParam.depth)
            setParam.memPanthers = panthersAppliCroissantOnce(scheme, schemeParams, MEMORY_ANALYSIS_ID, fileMem, setParam.depth)
            if execOrAnalyze == EXECUTION_ID :
                setParam.memCalibrated, setParam.compCalibrated = executePracticalAnalysis(appli, EXPLORATION_ID, "MiB_mem_tmp", scheme, schemeParams)

        else :
            raise Exception("panthersAppli: application ({}) is not in PAnTHErS (> {})".format(appli, MAX_APP_ID))

        fileComp.write(str(setParam.compCalibrated) + "\n" )
        fileMem.write(str(setParam.memCalibrated) + "\n" )

        progressBar.updateProgress(paramProgress)

        if execOrAnalyze == EXECUTION_ID :
            print(paramName + ") executed")
        if execOrAnalyze == ANALYZE_ID :
            print(paramName + ") analyzed")

def writeListParamAnalysis(fileName, listParam) :
    file = open(fileName + ".csv", "w")

    file.write("If scheme == FV or YASHE, Parameters = q, t, w\n")
    file.write("If scheme == FNTRU, Parameters = q, w\n")
    file.write("\n")
    file.write("Scheme\tDepth\tParameters\tComplexity\tMemory\tTime\tMiB\n")

    for i in range(len(listParam)) :
        scheme = listParam[i].scheme
        depth = listParam[i].depth
        p = listParam[i].params
        comp1 = listParam[i].compPanthers
        mem1 = listParam[i].memPanthers
        comp2 = listParam[i].compCalibrated
        mem2 = listParam[i].memCalibrated

        file.write(getSchemeName(scheme)+"\t")
        file.write(str(depth)+"\t")
        for i in range(len(p)) :
            file.write(str(p[i])+"\t")
        file.write(str(comp1)+"\t")
        file.write(str(mem1)+"\t")
        file.write(str(comp2)+"\t")
        file.write(str(mem2)+"\n")

    file.close()

def splitDepthSetList(filename, nbOfParts) :
    file = open(filename + ".csv", "r")
    paramsList = eval(file.read())
    file.close()

    listLength = len(paramsList)
    nbOfParams = floor(listLength / nbOfParts, bits=1000) + 1

    splittedList = [paramsList[i:i+nbOfParams] for i  in range(0, listLength, nbOfParams)]

    for i in range(len(splittedList)) :
        file = open(filename + "_part_" + str(i) + ".csv", "w")
        file.write(str(L[i]))
        file.close()

def readParams(fileName) :
    file = open(fileName + ".csv", "r")
    lines = file.readlines()
    file.close()

    params = []

    for i in range(4,len(lines)) :

        line = lines[i]
        line = line.split('\t')

        scheme = eval(line[0])
        depth = eval(line[1])
        q = eval(line[2])

        if scheme == FV_ID or scheme == YASHE_ID :
            t = eval(line[3])
            w = eval(line[4])
            compPanthers = eval(line[5])
            memPanthers = eval(line[6])
            compPractical = eval(line[7])
            memPractical = eval(line[8])

            param = ParamAnalyzed(-1, scheme, [q,t,w], compPanthers, memPanthers, compPractical, memPractical, depth)
            params.append(param)

        if scheme == FNTRU_ID :
            w = eval(line[3])
            compPanthers = eval(line[4])
            memPanthers = eval(line[5])
            compPractical = eval(line[6])
            memPractical = eval(line[7])

            param = ParamAnalyzed(-1, scheme, [q,w], compPanthers, memPanthers, compPractical, memPractical, depth)
            params.append(param)

    return params

def readAndDraw(fileNameIn, fileNameOut) :
    file = open(fileNameIn + ".csv", "r")
    lines = file.readlines()
    file.close()

    time = 0
    mib = 0

    pointsToDraw = []

    for i in range(4,len(lines),1) :
        line = lines[i]
        line = line.split('\t')
        point = [eval(line[len(line)-2]), eval(line[len(line)-1])]
        time = time + eval(line[len(line)-2])
        mib = mib + eval(line[len(line)-1])
        pointsToDraw = pointsToDraw + [point]

    generateGraph(["Complexity", "Memory"], pointsToDraw, fileNameOut)

    return time, mib

def executeCorners(appli, scheme, params, progressBar = 0) :
    fileComp = open("Res/Exploration/explo_parameters_executed_complexity_Appli" + getApplicationName(appli) + "_Scheme_" + getSchemeName(scheme) + ".csv", "w", 0)
    fileMem = open("Res/Exploration/explo_parameters_executed_memory_Appli" + getApplicationName(appli) + "_Scheme_" + getSchemeName(scheme) + ".csv", "w", 0)

    fileComp.write("Scheme\tParameters\tComplexity Theoretical\tExecution Time (sec)\n")
    fileMem.write("Scheme\tParameters\tMemory Theoretical\tMemory Cost (MiB)\n")

    if scheme == FV_ID or scheme == YASHE_ID :
        qmin = min(params, key=lambda mem: mem.params[0]).params[0]
        qmax = max(params, key=lambda mem: mem.params[0]).params[0]
        tmin = min(params, key=lambda mem: mem.params[1]).params[1]
        tmax = max(params, key=lambda mem: mem.params[1]).params[1]
        wmin = min(params, key=lambda mem: mem.params[2]).params[2]
        wmax = max(params, key=lambda mem: mem.params[2]).params[2]

        points = []

        for q in {qmin, qmax} :
            for w in {wmin, wmax} :
                for t in {tmin, tmax} :
                    param = ParamAnalyzed(appli, scheme, [q,t,w])
                    points = points + [param]

        panthersAppli(appli, scheme, points, EXECUTION_ID, fileComp, fileMem, progressBar)

    if scheme == FNTRU_ID :
        qmin = min(params, key=lambda mem: mem.params[0]).params[0]
        qmax = max(params, key=lambda mem: mem.params[0]).params[0]
        wmin = min(params, key=lambda mem: mem.params[1]).params[1]
        wmax = max(params, key=lambda mem: mem.params[1]).params[1]

        points = []

        for q in {qmin, qmax} :
            for w in {wmin, wmax} :
                param = ParamAnalyzed(appli, scheme, [q,w])
                points = points + [param]

        panthersAppli(appli, scheme, points, EXECUTION_ID, fileComp, fileMem, progressBar)

    fileComp.close()
    fileMem.close()

    return points

def analyzeEdges(appli, scheme, corners, progressBar = 0) :
    edges = []

    fileComp = open("Res/Exploration/explo_parameters_theoretical_complexity_Appli" + getApplicationName(appli) + "_Scheme_" + getSchemeName(scheme) + ".csv", "w", 0)
    fileMem = open("Res/Exploration/explo_parameters_theoretical_memory_Appli" + getApplicationName(appli) + "_Scheme_" + getSchemeName(scheme) + ".csv", "w", 0)

    fileComp.write("Scheme\tParameters\tComplexity Theoretical\n")
    fileMem.write("Scheme\tParameters\tMemory Theoretical\n")

    if scheme == FV_ID or scheme == YASHE_ID :
        qmin = min(corners, key=lambda mem: mem.params[0]).params[0]
        qmax = max(corners, key=lambda mem: mem.params[0]).params[0]
        tmin = min(corners, key=lambda mem: mem.params[1]).params[1]
        tmax = max(corners, key=lambda mem: mem.params[1]).params[1]
        wmin = min(corners, key=lambda mem: mem.params[2]).params[2]
        wmax = max(corners, key=lambda mem: mem.params[2]).params[2]

        if tmin != tmax :
            for t in {tmin, tmax} :
                for q in range(qmin, qmax+1) :
                    for w in range(wmin, wmax+1) :
                        param = ParamAnalyzed(appli, scheme, [q,t,w])
                        edges.append(param)

            panthersAppli(appli, scheme, edges, ANALYZE_ID, fileComp, fileMem, progressBar)

        else :
            for w in {wmin, wmax} :
                for q in range(qmin, qmax+1) :
                        param = ParamAnalyzed(appli, scheme, [q,tmin,w])
                        edges.append(param)

            panthersAppli(appli, scheme, edges, ANALYZE_ID, fileComp, fileMem, progressBar)

    if scheme == FNTRU_ID :
        qmin = min(corners, key=lambda mem: mem.params[0]).params[0]
        qmax = max(corners, key=lambda mem: mem.params[0]).params[0]
        wmin = min(corners, key=lambda mem: mem.params[1]).params[1]
        wmax = max(corners, key=lambda mem: mem.params[1]).params[1]

        for w in {wmin, wmax} :
            for q in range(qmin, qmax+1) :
                    param = ParamAnalyzed(appli, scheme, [q,w])
                    edges.append(param)

        panthersAppli(appli, scheme, edges, ANALYZE_ID, fileComp, fileMem, progressBar)

    fileComp.close()
    fileMem.close()

    return edges

def appliExploration(appli, schemeExplored, tabMinMax, progressBar = 0, exploreType = 0, secu = 0, depth = 0, compMax = 0, memMax = 0) :
    """ appli = 0 (medical), 1 (toy), 2 (fiveHB), 3 (Croissant)
        exploreType = 0 (best ratio between Comp/Mem), 1 (best Comp), 2 (best Mem)
        compMax = float (default: 0)
        memMax = float (default: 0) """

    time1 = time.time()

    if depth == 0 :
        depth = getApplicationDepth(appli)

    allSchemeParams = []

    progressBar.configure("Explo: Application Parameter Selection")
    print("Application: " + getApplicationName(appli))

    for scheme in schemeExplored :
        allSchemeParams = appliExplorationScheme(appli, scheme, allSchemeParams, tabMinMax, progressBar, exploreType, secu, depth, compMax, memMax)

    if allSchemeParams == [] :
        progressBar.configure("Explo: no parameters found - restart")
        raise Exception("appliExploration: no set of input parameters of every schemes implies a {}-bit security for a depth = {}.".format(secu, depth))

    if exploreType == EXPLO_TYPE_COMPLEXITY :
        # Find set of parameters that implies the lowest execution time estimation
        optimizedPoints = [min(allSchemeParams, key=lambda comp: comp.compCalibrated)]
        allSchemeParamsSorted = sorted(allSchemeParams, key = lambda comp: comp.compCalibrated)

    elif exploreType == EXPLO_TYPE_MEMORY :
        # Find set of parameters that implies the lowest memory cost estimation
        optimizedPoints = [min(allSchemeParams, key=lambda mem: mem.memCalibrated)]
        allSchemeParamsSorted = sorted(allSchemeParams, key = lambda mem: mem.memCalibrated)

    else :
        # Find sets of parameters that implies best compromise between execution time and memory cost estimations
        optimizedPoints = paretoCriterion(allSchemeParams)
        allSchemeParamsSorted = paretoLevelsSort(allSchemeParams)

    time2 = time.time()

    progressBar.updateProgress(100)
    progressBar.configure("Explo: Graph Generation")

    writeListParamAnalysis("Res/Exploration/explo_parameters_completed_Pareto_sorted_Appli"+getApplicationName(appli), allSchemeParamsSorted)
    generateGraphParamAnalyzed(["Complexity (s)", "Memory cost (MiB)"], allSchemeParamsSorted, "Res/Graphs/explo_Appli"+getApplicationName(appli)+"_graph")
    writeListParamAnalysis("Res/Exploration/explo_optimized_points_Appli"+getApplicationName(appli), optimizedPoints)

    progressBar.updateProgress(100)

    print("Total Exploration Time : ", time2-time1)

    return allSchemeParamsSorted, optimizedPoints

def appliExplorationScheme(appli, scheme, allSchemeParams, tabMinMax, progressBar = 0, exploreType = 0, secu = 0, depth = 0, compMax = 0, memMax = 0) :
    schemeName = getSchemeName(scheme)
    # Find all sets of parameters implying the multiplicative depth of the application
    progressBar.configure("Explo: find all parameters")
    allParams, schemeParams = findParamsForDepth(scheme, tabMinMax, depth, secu, progressBar)

    if allParams != [] :
        # Analyze complexity and memory of application for each set of parameters
        fileComp = open("Res/Exploration/explo_All_parameters_theoretical_complexity_Appli" + getApplicationName(appli) + "_Scheme_" + getSchemeName(scheme) + ".csv", "w", 0)
        fileMem = open("Res/Exploration/explo_All_parameters_theoretical_memory_Appli" + getApplicationName(appli) + "_Scheme_" + getSchemeName(scheme) + ".csv", "w", 0)
        fileComp.write("Scheme\tParameters\tComplexity Theoretical\n")
        fileMem.write("Scheme\tParameters\tMemory Theoretical\n")

        print("Analyze All Parameters")
        progressBar.configure("Explo: Analyze All Parameters")
        panthersAppli(appli, scheme, allParams, ANALYZE_ID, fileComp, fileMem, progressBar)
        print("Analyze All Parameters: Done")

        fileComp.close()
        fileMem.close()

        # Execution of few sets of parameters
        print("Execution before calibration")
        progressBar.configure("Explo: Execution before calibration")
        corners = executeCorners(appli, scheme, allParams, progressBar)
        print("Execution before calibration: Done")

        # Analyze required before first calibrations
        print("Analyses before pre-calibration")
        progressBar.configure("Explo: Analyses before calibration")
        edges = analyzeEdges(appli, scheme, corners, progressBar)
        print("Analyses before pre-calibration: Done")

        # First calibrations
        print("Pre-calibration")
        progressBar.configure("Explo: Pre-calibration")
        cornersAndEdges = calibrateEdges(scheme, corners, edges+corners, progressBar)
        print("Pre-calibration: Done")
        writeListParamAnalysis("Res/Exploration/explo_pre_calibration_Appli" + getApplicationName(appli) + "_Scheme_" + schemeName, cornersAndEdges)

        # Calibration of all sets in allParams
        print("Calibration")
        progressBar.configure("Explo: Calibration")
        calibrateEveryPoints(scheme, cornersAndEdges, allParams, progressBar)
        print("Calibration: Done")
        writeListParamAnalysis("Res/Exploration/explo_all_parameters_calibrated_Appli" + getApplicationName(appli) + "_Scheme_" + schemeName, allParams)

        pointsList = allParams

        progressBar.configure("Explo: Scheme Parameter Selection")

        # If compMax or memMax > 0
        if memMax != 0 and compMax != 0 :
            # Find sets of parameters which has a memory < memMax and an execution time < compMax
            pointsList = [pointsList[i] for i in range(len(pointsList)) if pointsList[i].memCalibrated < memMax and pointsList[i].compCalibrated < compMax]
        # If only compMax > 0
        elif compMax != 0 :
            # Find sets of parameters (and sort them) depending on execution time < compMax
            pointsList = [pointsList[i] for i in range(len(pointsList)) if pointsList[i].compCalibrated < compMax]
        # If only memMax > 0
        elif memMax != 0 :
            # Find sets of parameters (and sort them) depending on memory < memMax
            pointsList = [pointsList[i] for i in range(len(pointsList)) if pointsList[i].memCalibrated < memMax]

        # Write results on file
        if allParams != pointsList :
            writeListParamAnalysis("Res/Exploration/explo_all_parameters_calibrated_filter_Appli"+getApplicationName(appli)+"_Scheme_" + schemeName, pointsList)

        # Add results in global table
        allSchemeParams = allSchemeParams + pointsList

        progressBar.updateProgress(100)

    return allSchemeParams
