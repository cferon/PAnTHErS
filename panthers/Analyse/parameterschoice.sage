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


from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler
from subprocess import *
import os
import re

primes = Primes()

def findPolyDegree(qq, secu) :
    if secu == 80 :
        if qq <= 46 :
            n1 = 2^9
            d = 2^10
        elif qq > 46 and qq <= 88 :
            n1 = 2^10
            d = 2^11
        elif qq > 88 and qq <= 174 :
            n1 = 2^11
            d = 2^12
        elif qq > 174 and qq <= 348 :
            n1 = 2^12
            d = 2^13
        elif qq > 348 :
            n1 = 2^13
            d = 2^14
        return [n1, d]
    elif secu == 128 :
        if qq <= 30 :
            n1 = 2^9
            d = 2^10
        elif qq > 30 and qq <= 58 :
            n1 = 2^10
            d = 2^11
        elif qq > 58 and qq <= 112 :
            n1 = 2^11
            d = 2^12
        elif qq > 112 and qq <= 222 :
            n1 = 2^12
            d = 2^13
        elif qq > 222 :
            n1 = 2^13
            d = 2^14
        return [n1, d]
    else :
        raise Exception("chooseFVParameter: secu = {} != 80 and != 128".format(secu))

def chooseFVParameter(qq,tt,ww,secu = 80) :
    q = 2^qq-1
    t = tt
    [n1,d] = findPolyDegree(qq,secu)
    delta = q//t
    w = 2^ww
    sigma = 0.5
    bKey = 1
    bErr = 9.2 * 2 * sqrt(n1)
    expFact = d

    R.<z> = PolynomialRing(ZZ)
    R2.<y> = PolynomialRing(ZZ.quo(t*ZZ))
    fy= y^d+1
    R2.<Y> = R2.quo([fy])

    Dkey = DiscreteGaussianDistributionPolynomialSampler(R, d, sigma)
    Derr = DiscreteGaussianDistributionPolynomialSampler(R, d, 2*sqrt(n1))

    return [d,d,q,w,t,bKey,bErr,expFact] , [R,Derr,Dkey]

def chooseYASHEParameter(qq,tt,ww,secu = 80) :
    primes = Primes()
    q = primes.next(2^qq-1)
    t = tt
    [n1,d] = findPolyDegree(qq,secu)
    w = 2^ww
    sigma = 0.5
    bKey = 1
    bErr = 9.2 * 2 * sqrt(n1)

    R.<z> = PolynomialRing(ZZ)
    R2.<y> = PolynomialRing(ZZ.quo(t*ZZ))
    fy= y^d+1
    R2.<Y> = R2.quo([fy])

    Dkey = DiscreteGaussianDistributionPolynomialSampler(R, d, sigma)
    Derr = DiscreteGaussianDistributionPolynomialSampler(R, d, 2*sqrt(n1))

    return [q,d,w,t,bErr,bKey] , [R,Derr,Dkey]

def chooseFNTRUParameter(qq,ww,secu = 80) :
    primes = Primes()
    q = primes.next(2^qq-1)
    [n1,d] = findPolyDegree(qq,secu)
    w = 2^ww
    sigma = 0.5
    bKey = 1
    bErr = 9.2*2*sqrt(n1)

    R.<z> = PolynomialRing(ZZ)
    R2.<y> = PolynomialRing(ZZ.quo(2*ZZ))
    fy= y^d+1
    R2.<Y> = R2.quo([fy])

    Dkey = DiscreteGaussianDistributionPolynomialSampler(R, d, sigma)
    Derr = DiscreteGaussianDistributionPolynomialSampler(R, d, 2*sqrt(n1))

    return [q,d,w,bErr,bKey] , [R,Derr,Dkey]

def chooseParameter(scheme, params, secu = 80) :
    if scheme == FV_ID :
        if len(params) != 3 :
            raise Exception("chooseParameter: there is not 3 parameters (but {}) in params".format(len(params)))

        qq = params[0].currentValue
        tt = params[1].currentValue
        ww = params[2].currentValue

        return chooseFVParameter(qq,tt,ww,secu)

    elif scheme == YASHE_ID :
        if len(params) != 3 :
            raise Exception("chooseParameter: there is not 3 parameters (but {}) in params".format(len(params)))

        qq = params[0].currentValue
        tt = params[1].currentValue
        ww = params[2].currentValue

        return chooseYASHEParameter(qq,tt,ww,secu)
    elif scheme == FNTRU_ID :
        if len(params) != 2 :
            raise Exception("chooseParameter: there is not 2 parameters (but {}) in params".format(len(params)))

        qq = params[0].currentValue
        ww = params[1].currentValue

        return chooseFNTRUParameter(qq,ww,secu)
    else :
        raise Exception("chooseParameter: Scheme ({}) is not in PAnTHErS library.")

def createSchemeObject(scheme, params, sets, whichAnalysis) :
    if whichAnalysis >= MAX_MODE_ID :
        raise Exception("whichAnalysis ({}) has to be = 1 for execution, = 2 for complexity analysis, = 3 for memory cost analysis, = 3 for exploration".format(whichAnalysis))

    if scheme == FV_ID :
        if whichAnalysis == EXECUTION_ID : #execution
            return FV12(params, sets, "HEBasic", "")
        elif whichAnalysis == COMPLEXITY_ANALYSIS_ID : #complexity
            return FV12Complexity(params, sets, "HEBasic", "")
        elif whichAnalysis == MEMORY_ANALYSIS_ID : #memory cost
            return FV12Memory(params, sets, "HEBasic", "")
    elif scheme == YASHE_ID :
        if whichAnalysis == EXECUTION_ID : #execution
            return YASHE(params, sets, "HEBasic", "")
        elif whichAnalysis == COMPLEXITY_ANALYSIS_ID : #complexity
            return YASHEComplexity(params, sets, "HEBasic", "")
        elif whichAnalysis == MEMORY_ANALYSIS_ID : #memory cost
            return YASHEMemory(params, sets, "HEBasic", "")
    elif scheme == FNTRU_ID :
        if whichAnalysis == EXECUTION_ID : #execution
            return FNTRU(params, sets, "HEBasic", "")
        elif whichAnalysis == COMPLEXITY_ANALYSIS_ID : #complexity
            return FNTRUComplexity(params, sets, "HEBasic", "")
        elif whichAnalysis == MEMORY_ANALYSIS_ID : #memory cost
            return FNTRUMemory(params, sets, "HEBasic", "")
    else :
        raise Exception("createSchemeWithPlaintextsAppliMedical : Scheme ({}) is not in PAnTHErS library.".format(scheme))

def depthAppliCheck(appli, scheme, params) :
    appliDepth = getApplicationDepth(appli)

    for i in range(len(params)) :
        if not(params[i].isFixed) :
            paramsCopy = [ParamVariation(params[k]) for k in range(len(params))]
            for j in range(len(paramsCopy)) :
                if i != j :
                    paramsCopy[j].isFixed = True

            for param in paramsCopy :
                param.getInitParamVariationValue()

            isTerminated = False
            for param in paramsCopy :
                isTerminated = isTerminated or param.isMaxValueReached()

            while not(isTerminated) :
                paramsIn, sets = chooseParameter(scheme, paramsCopy)
                schemeObject = createSchemeObject(scheme, paramsIn, sets, EXECUTION_ID)
                schemeDepth = 0
                schemeDepth = schemeObject.depth()

                if schemeDepth < appliDepth :
                    return 0, "Depth error: " + str(schemeDepth) + " < " + str(appliDepth)

                for param in paramsCopy :
                    param.getNextParamVariationValue()

                isTerminated = False
                for param in paramsCopy :
                    isTerminated = isTerminated or param.isMaxValueReached()

            for param in paramsCopy :
                param.currentValue = 0

    return 1, "Depth ok: all depths are > " +  str(appliDepth)

def retrievePracticalAnalysis(appli, whichAnalysis, fileName) :
    file = open("Tmp/" + fileName + ".log", "r")
    text = file.readlines()
    file.close()

    indexMem = 0
    indexComp = 0

    for i in range(len(text)) :
        if "computeApplication"+ getApplicationName(appli) in text[i] :
            indexMem = i
        if "TimeExecuteAppli"+ getApplicationName(appli) + "Once" in text[i] :
            indexComp = i

    lineMem = text[indexMem]
    lineMem = re.sub("\s+", " ", lineMem)
    lineMem = lineMem.split(" ")[4]

    lineComp = text[indexComp]
    lineComp = re.sub("\s+", " ", lineComp)
    lineComp = lineComp.split(" ")[1]

    if whichAnalysis == EXPLORATION_ID or whichAnalysis == EXECUTION_ID : #explo or exec
        return float(lineMem), float(lineComp)
    elif whichAnalysis == COMPLEXITY_ANALYSIS_ID : #comp
        return float(lineComp)
    elif whichAnalysis == MEMORY_ANALYSIS_ID : #mem
        return float(lineMem)
    else :
        raise Exception("retrievePracticalAnalysis: whichAnalysis({}) is not 1 for comp or 2 for mem or 3 for explo.".format(whichAnalysis))

def executePracticalAnalysis(appli, whichAnalysis, fileName, scheme, paramsIn, progressBar = 0) :
    file = open("Tmp/" + fileName + ".log", "w", 0)
    memCost = 0
    infoFileName = "Tmp/executePracticalAnalysis_info.dat"

    count = 0
    for param in paramsIn :
        param.save("Tmp/"+ str(count)+".dat")
        count = count + 1

    nbOfParamsIn = str(len(paramsIn))
    infoFile = open(infoFileName, "w")
    infoFile.write(nbOfParamsIn)
    infoFile.write("\n")
    infoFile.write(str(scheme))
    infoFile.close()

    out = 0
    if appli == MEDICAL_ID :
        print("executePracticalAnalysis: appli Med")
        out = check_output(["sage", "-c", "os.system('sage < medScript.sagescript')"])
    elif appli == TOY_ID :
        print("executePracticalAnalysis: appli Toy")
        out = check_output(["sage", "-c", "os.system('sage < toyScript.sagescript')"])
    elif appli == FIVEHB_ID :
        print("executePracticalAnalysis: appli FiveHB")
        out = check_output(["sage", "-c", "os.system('sage < fiveHBScript.sagescript')"])
    elif appli == CROISSANT_ID :
        print("executePracticalAnalysis: appli Croissant")
        out = check_output(["sage", "-c", "os.system('sage < croissantScript.sagescript')"])
    else :
        raise Exception("executePracticalAnalysis: appli ({}) is not available (> {})".format(appli, MAX_APP_ID))

    file.write(out)
    file.close()
    cost = retrievePracticalAnalysis(appli, whichAnalysis, fileName)

    return cost
