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


def generateGraph(axeName, points, fileName) :
    graph = list_plot(points, plotjoined = True, color='blue')
    graph.axes_labels(axeName)
    graph.save("Res/Graphs/" + fileName + ".png")

def generateGraphParamAnalyzed(axeName, params, fileName) :
    g = Graphics()
    color = ['blue', 'red', 'green', 'purple']

    for scheme in {0,1,2} :
        points = []
        for i in range(len(params)) :
            if params[i].scheme == scheme :
                points = points + [(params[i].compCalibrated, params[i].memCalibrated)]
        g += list_plot(points, color=color[scheme])
    g.axes_labels(axeName)
    g.save(fileName + ".png")

    g = Graphics()
    color = ['blue', 'red', 'green', 'purple']

    for scheme in {0,1,2} :
        points = []
        for i in range(len(params)) :
            if params[i].scheme == scheme :
                points = points + [(params[i].compPanthers, params[i].memPanthers)]
        g += list_plot(points, color=color[scheme])
    g.axes_labels(["Complexity", "Memory"])
    g.save("Res/Graphs/explo_Graph_with_parameters_nonCalibrated.png")

def paretoCriterion(listPoints) :
    paretoPoints = []

    for point in listPoints :
        isToAdd = True
        paretoPointsCopy = list(paretoPoints)

        for paretopoint in paretoPointsCopy :
            xPareto = paretopoint.compCalibrated
            yPareto = paretopoint.memCalibrated

            xPoint = point.compCalibrated
            yPoint =  point.memCalibrated

            if xPareto > xPoint and yPareto > yPoint :
                paretoPoints.remove(paretopoint)
            if xPoint >= xPareto and yPoint >= yPareto :
                isToAdd = False
                break
        if isToAdd :
            paretoPoints = paretoPoints + [point]

    return paretoPoints

# Find in which Pareto level are the point in chosenPoints
# ParetoCriterion is applied on listPoints. Points find are removed from listPoints and ParetoCriterion is called again and so on...
# Points in different pareto levels are put in a list of list.
def paretoLevels(listPoints, chosenPoints) :
    levels = []
    indexes = []
    nbTotalOfPoints = len(listPoints)
    nbOfPointsBelow = 0

    listPointsCopy = list(listPoints)
    chosenPointsCopy = list(chosenPoints)

    while chosenPointsCopy != [] :
        oneLevel = paretoCriterion(listPointsCopy)
        levels.append([oneLevel])
        for point in chosenPoints :
            if point in oneLevel :
                indexes.append((point, nbOfPointsBelow, len(oneLevel)))
                chosenPointsCopy.remove(point)
        nbOfPointsBelow = nbOfPointsBelow + len(oneLevel)
        for point in oneLevel :
            listPointsCopy.remove(point)

    return indexes, nbTotalOfPoints

def paretoLevelsSort(listPoints) :
    pointsSorted = []
    listPointsCopy = list(listPoints)

    while listPointsCopy != [] :
        paretoPoints = paretoCriterion(listPointsCopy)
        pointsSorted = pointsSorted + paretoPoints
        for point in paretoPoints :
            listPointsCopy.remove(point)

    return pointsSorted
