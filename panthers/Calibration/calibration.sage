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


def calibrate(practicalValues, pointsToCalibrate) :
    """ practicalValues = list of tuples. Ex : [(1,2), (1,5)]
        pointsToCalibrate = list of tuples. """
    nbOfPoints = len(practicalValues)
    panthersMatrix = []
    practicalMatrix = []
    for i in range(nbOfPoints) :
        for j in range(len(pointsToCalibrate)) :
            if practicalValues[i][0] == pointsToCalibrate[j][0] :
                practicalMatrix = practicalMatrix + [[practicalValues[i][1]]]
                panthersMatrix = panthersMatrix + [[pointsToCalibrate[j][1]^k for k in range(nbOfPoints-1,-1,-1)]]
    panthersMatrix = matrix(RR, panthersMatrix)

    pointsCalibrated = []

    if panthersMatrix.is_invertible() :
        practicalMatrix = matrix(RR, practicalMatrix)
        systemResolution = panthersMatrix.inverse()*practicalMatrix

        for i in range(len(pointsToCalibrate)) :
            yCalibrated = 0
            for j in range(systemResolution.nrows()) :
                yCalibrated = yCalibrated + systemResolution[j][0]*pointsToCalibrate[i][1]^(nbOfPoints - j -1)
            pointsCalibrated = pointsCalibrated + [(pointsToCalibrate[i][0], yCalibrated)]

    else : #tuple[1] are identicals for every pointsToCalibrate
        moyenne = 0
        for i in range(len(practicalMatrix)) :
            moyenne = moyenne + practicalMatrix[i][0]
        moyenne = float(moyenne) / len(practicalMatrix)

        factor = float(moyenne) / float(pointsToCalibrate[0][1])

        for i in range(len(pointsToCalibrate)) :
            pointsCalibrated = pointsCalibrated + [(pointsToCalibrate[i][0], pointsToCalibrate[i][1]*factor)]

    return pointsCalibrated

def calibrateParamAnalyzed(practicalValues, pointsToCalibrate) :
    """ pointsToCalibrate = list of ParamAnalyzed."""

    nbOfPoints = len(practicalValues)

    panthersMatrixComp = []
    panthersMatrixMem = []
    practicalMatrixComp = []
    practicalMatrixMem = []

    if pointsToCalibrate == [] :
        return

    for i in range(nbOfPoints) :
        practicalMatrixComp = practicalMatrixComp + [[practicalValues[i].compCalibrated]]
        panthersMatrixComp = panthersMatrixComp + [[practicalValues[i].compPanthers^k for k in range(nbOfPoints-1,-1,-1)]]

        practicalMatrixMem = practicalMatrixMem + [[practicalValues[i].memCalibrated]]
        panthersMatrixMem = panthersMatrixMem + [[practicalValues[i].memPanthers^k for k in range(nbOfPoints-1,-1,-1)]]

    panthersMatrixComp = matrix(RR, panthersMatrixComp)
    panthersMatrixMem = matrix(RR, panthersMatrixMem)

    #Complexity case
    if panthersMatrixComp.is_invertible() :
        practicalMatrixComp = matrix(RR, practicalMatrixComp)
        systemResolutionComp = panthersMatrixComp.solve_right(practicalMatrixComp)

        for param in pointsToCalibrate :
            finalComp = 0
            for j in range(systemResolutionComp.nrows()) :
                finalComp = finalComp + systemResolutionComp[j][0]*param.compPanthers^(nbOfPoints - j -1)
            finalComp = float(finalComp)
            if param.compCalibrated == 0 :
                param.compCalibrated = finalComp

    else : #tuple[1] are identicals for every pointsToCalibrate
        moyenne = 0
        for i in range(len(practicalMatrixComp)) :
            moyenne = moyenne + practicalMatrixComp[i][0]
        moyenne = float(moyenne) / len(practicalMatrixComp)

        factor = float(moyenne) / float(pointsToCalibrate[0].compPanthers)

        for param in pointsToCalibrate :
            finalComp = param.compPanthers*factor
            if param.compCalibrated == 0 :
                param.compCalibrated = finalComp

    #Memory case
    if panthersMatrixMem.is_invertible() :
        practicalMatrixMem = matrix(RR, practicalMatrixMem)
        systemResolutionMem = panthersMatrixMem.solve_right(practicalMatrixMem)

        for param in pointsToCalibrate :
            finalMem = 0
            for j in range(systemResolutionMem.nrows()) :
                finalMem = finalMem + systemResolutionMem[j][0]*param.memPanthers^(nbOfPoints - j -1)
            finalMem = float(finalMem)
            if param.memCalibrated == 0 :
                param.memCalibrated = finalMem

    else : #tuple[1] are identicals for every pointsToCalibrate
        moyenne = 0
        for i in range(len(practicalMatrixMem)) :
            moyenne = moyenne + practicalMatrixMem[i][0]
        moyenne = float(moyenne) / len(practicalMatrixMem)

        factor = float(moyenne) / float(pointsToCalibrate[0].memPanthers)

        for param in pointsToCalibrate :
            finalMem = param.memPanthers*factor
            if param.memCalibrated == 0 :
                param.memCalibrated = finalMem

def updateListParamAnalyzed(listToUpdate, fullParam) :
    for param in fullParam :
        for i in range(len(listToUpdate)) :
            if param == listToUpdate[i] :
                listToUpdate[i].compPanthers = param.compPanthers
                listToUpdate[i].memPanthers = param.memPanthers
                listToUpdate[i].compCalibrated = param.compCalibrated
                listToUpdate[i].memCalibrated = param.memCalibrated
                break
    return listToUpdate

def resetDouble(practicalValues) :
    if len(practicalValues) != 2 :
        practicalValuesTmp = []

        for j in range(len(practicalValues)) :
            isInList = False
            for i in range(len(practicalValuesTmp)) :
                if practicalValues[j] == practicalValuesTmp[i] :
                    isInList = True
            if not(isInList) :
                practicalValuesTmp = practicalValuesTmp + [practicalValues[j]]

        return practicalValuesTmp

    return practicalValues

def calibrateEdges(scheme, pointsExecuted, pointsToCalibrate, progressBar = 0) :
    if scheme == 0 or scheme == 1 : #FV and YASHE
        qmin = min(pointsToCalibrate, key=lambda mem: mem.params[0]).params[0]
        qmax = max(pointsToCalibrate, key=lambda mem: mem.params[0]).params[0]
        tmin = min(pointsToCalibrate, key=lambda mem: mem.params[1]).params[1]
        tmax = max(pointsToCalibrate, key=lambda mem: mem.params[1]).params[1]
        wmin = min(pointsToCalibrate, key=lambda mem: mem.params[2]).params[2]
        wmax = max(pointsToCalibrate, key=lambda mem: mem.params[2]).params[2]

        if tmin != tmax :

            paramProgress = 100.0/(len({tmin, tmax})*len({wmin, wmax}) + len(range(qmin, qmax+1))*len({tmin, tmax}))

            for t in {tmin, tmax} :
                for w in {wmin, wmax} :
                    points = []
                    practicalValues = []
                    for i in range(len(pointsToCalibrate)) :
                        if pointsToCalibrate[i].params[1] == t and pointsToCalibrate[i].params[2] == w :
                            points.append(pointsToCalibrate[i])
                    for i in range(len(pointsExecuted)) :
                        if pointsExecuted[i].params[1] == t and pointsExecuted[i].params[2] == w :
                            practicalValues.append(pointsExecuted[i])
                    practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[0])
                    practicalValues = resetDouble(practicalValues)
                    points = sorted(points, key = lambda analysis: analysis.params[0])
                    calibrateParamAnalyzed(practicalValues, points)
                    pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

                    progressBar.updateProgress(paramProgress)

            print("Pre-calibration for min and max q with parameters t and w fixed (min and max): Done")

            for t in {tmin, tmax} :
                for q in range(qmin, qmax+1) :
                    points = []
                    practicalValues = []
                    for i in range(len(pointsToCalibrate)) :
                        if pointsToCalibrate[i].params[1] == t and pointsToCalibrate[i].params[0] == q :
                            points = points + [pointsToCalibrate[i]]
                    for i in range(len(pointsToCalibrate)) :
                        if pointsToCalibrate[i].params[0] == q and pointsToCalibrate[i].params[1] == t and (pointsToCalibrate[i].params[2] == wmax or pointsToCalibrate[i].params[2] == wmin) :
                            practicalValues = practicalValues + [pointsToCalibrate[i]]
                    practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[2])
                    practicalValues = resetDouble(practicalValues)
                    points = sorted(points, key = lambda analysis: analysis.params[2])
                    calibrateParamAnalyzed(practicalValues, points)
                    pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

                    progressBar.updateProgress(paramProgress)

            print("Pre-calibration for every q with parameters t and w fixed (min and max): Done")

        else :

            paramProgress = 100.0/len({wmin, wmax})

            for w in {wmin, wmax} :
                points = []
                practicalValues = []
                for i in range(len(pointsToCalibrate)) :
                    if pointsToCalibrate[i].params[2] == w :
                        points.append(pointsToCalibrate[i])
                for i in range(len(pointsExecuted)) :
                    if pointsExecuted[i].params[2] == w :
                        practicalValues.append(pointsExecuted[i])
                practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[0])
                points = sorted(points, key = lambda analysis: analysis.params[0])
                practicalValues = resetDouble(practicalValues)
                calibrateParamAnalyzed(practicalValues, points)
                pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

                progressBar.updateProgress(paramProgress)

            print("Pre-calibration for every q with parameter w fixed (min and max): Done")

    if scheme == 2 : #FNTRU
        qmin = min(pointsToCalibrate, key=lambda mem: mem.params[0]).params[0]
        qmax = max(pointsToCalibrate, key=lambda mem: mem.params[0]).params[0]
        wmin = min(pointsToCalibrate, key=lambda mem: mem.params[1]).params[1]
        wmax = max(pointsToCalibrate, key=lambda mem: mem.params[1]).params[1]

        paramProgress = 100.0/len({wmin, wmax})

        for w in {wmin, wmax} :
            points = []
            practicalValues = []
            for i in range(len(pointsToCalibrate)) :
                if pointsToCalibrate[i].params[1] == w :
                    points.append(pointsToCalibrate[i])
            for i in range(len(pointsExecuted)) :
                if pointsExecuted[i].params[1] == w :
                    practicalValues.append(pointsExecuted[i])
            practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[0])
            points = sorted(points, key = lambda analysis: analysis.params[0])
            practicalValues = resetDouble(practicalValues)
            calibrateParamAnalyzed(practicalValues, points)
            pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

            progressBar.updateProgress(paramProgress)

        print("Pre-calibration for every q with parameter w fixed (min and max): Done")

    return pointsToCalibrate

def calibrateEveryPoints(scheme, cornersAndEdges, pointsToCalibrate, progressBar = 0) :
    if scheme == 0 or scheme == 1 : #FV and YASHE
        qmin = min(cornersAndEdges, key=lambda mem: mem.params[0]).params[0]
        qmax = max(cornersAndEdges, key=lambda mem: mem.params[0]).params[0]
        tmin = min(cornersAndEdges, key=lambda mem: mem.params[1]).params[1]
        tmax = max(cornersAndEdges, key=lambda mem: mem.params[1]).params[1]
        wmin = min(cornersAndEdges, key=lambda mem: mem.params[2]).params[2]
        wmax = max(cornersAndEdges, key=lambda mem: mem.params[2]).params[2]

        pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, cornersAndEdges)

        if tmin != tmax :

            paramProgress = 100.0/(len(range(qmin, qmax+1)) * len(range(wmin, wmax+1)))

            for q in range(qmin, qmax+1) :
                for w in range(wmin, wmax+1) :
                    points = []
                    practicalValues = []
                    for i in range(len(cornersAndEdges)) :
                        if cornersAndEdges[i].params[0] == q and cornersAndEdges[i].params[2] == w :
                            practicalValues = practicalValues + [cornersAndEdges[i]]
                    for i in range(len(pointsToCalibrate)) :
                        if pointsToCalibrate[i].params[0] == q and pointsToCalibrate[i].params[2] == w :
                            points = points + [pointsToCalibrate[i]]
                    practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[1])
                    practicalValues = resetDouble(practicalValues)
                    points = sorted(points, key = lambda analysis: analysis.params[1])
                    calibrateParamAnalyzed(practicalValues, points)
                    pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

                    progressBar.updateProgress(paramProgress)

        else :

            paramProgress = 100.0/len(range(qmin, qmax+1))

            for q in range(qmin, qmax+1) :
                points = []
                practicalValues = []
                for i in range(len(cornersAndEdges)) :
                    if cornersAndEdges[i].params[0] == q :
                        practicalValues = practicalValues + [cornersAndEdges[i]]
                for i in range(len(pointsToCalibrate)) :
                    if pointsToCalibrate[i].params[0] == q :
                        points = points + [pointsToCalibrate[i]]
                practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[2])
                practicalValues = resetDouble(practicalValues)
                points = sorted(points, key = lambda analysis: analysis.params[2])
                calibrateParamAnalyzed(practicalValues, points)
                pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

                progressBar.updateProgress(paramProgress)

    if scheme == 2 : #FNTRU
        qmin = min(cornersAndEdges, key=lambda mem: mem.params[0]).params[0]
        qmax = max(cornersAndEdges, key=lambda mem: mem.params[0]).params[0]
        wmin = min(cornersAndEdges, key=lambda mem: mem.params[1]).params[1]
        wmax = max(cornersAndEdges, key=lambda mem: mem.params[1]).params[1]

        pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, cornersAndEdges)

        paramProgress = 100/len(range(qmin, qmax+1))

        for q in range(qmin, qmax+1) :
            points = []
            practicalValues = []
            for i in range(len(cornersAndEdges)) :
                if cornersAndEdges[i].params[0] == q :
                    practicalValues = practicalValues + [cornersAndEdges[i]]
            for i in range(len(pointsToCalibrate)) :
                if pointsToCalibrate[i].params[0] == q :
                    points = points + [pointsToCalibrate[i]]
            practicalValues = sorted(practicalValues, key = lambda analysis: analysis.params[1])
            practicalValues = resetDouble(practicalValues)
            points = sorted(points, key = lambda analysis: analysis.params[1])
            calibrateParamAnalyzed(practicalValues, points)
            pointsToCalibrate = updateListParamAnalyzed(pointsToCalibrate, points)

            progressBar.updateProgress(paramProgress)

    return pointsToCalibrate
