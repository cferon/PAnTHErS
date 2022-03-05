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


class ParamVariation(object) :
    """ ParamVariation represents variation (min to max by step) for one parameter.
		If the parameter is fixed (isFixed == True), then its value is the default value. """

    def __init__(self, name, min = 0, max = 0, step = 0, isFixed = True, default = 0, currentValue = 0) :
        if isinstance(name, ParamVariation) :
            min = name.min
            max = name.max
            step = name.step
            isFixed = name.isFixed
            default = name.default
            currentValue = name.currentValue
            name = name.name
        self.__name = name
        self.__min = min
        self.__max = max
        self.__step = step
        self.__isFixed = isFixed
        self.__default = default
        self.__currentValue = currentValue

    @property
    def name(self) :
        return self.__name

    @name.setter
    def name(self, name) :
        self.__name = name

    @property
    def min(self) :
        return self.__min

    @min.setter
    def min(self, min) :
        self.__min = min

    @property
    def max(self) :
        return self.__max

    @max.setter
    def max(self, max) :
        self.__max = max

    @property
    def step(self) :
        return self.__step

    @step.setter
    def step(self, step) :
        self.__step = step

    @property
    def isFixed(self) :
        return self.__isFixed

    @isFixed.setter
    def isFixed(self, isFixed) :
        self.__isFixed = isFixed

    @property
    def default(self) :
        return self.__default

    @default.setter
    def default(self, default) :
        self.__default = default

    @property
    def currentValue(self) :
        return self.__currentValue

    @currentValue.setter
    def currentValue(self, currentValue) :
        self.__currentValue = currentValue

    def getNextParamVariationValue(self) :
        if self.isFixed :
            self.currentValue = self.default
        else :
            self.currentValue = self.currentValue + self.step

    def getInitParamVariationValue(self) :
        if self.isFixed :
            self.currentValue = self.default
        else :
            self.currentValue = self.min

    def isMaxValueReached(self) :
        if self.isFixed :
            return False
        else :
            if self.currentValue > self.max :
                return True
            else :
                return False

    def save(self, fileName) :
        file = open(fileName + ".dat", "w")
        file.write(self.name)
        file.write("\n")
        file.write(str(self.min))
        file.write("\n")
        file.write(str(self.max))
        file.write("\n")
        file.write(str(self.step))
        file.write("\n")
        file.write(str(self.isFixed))
        file.write("\n")
        file.write(str(self.default))
        file.write("\n")
        file.write(str(self.currentValue))
        file.close()

    def load(self, fileName) :
        file = open(fileName + ".dat", "r")
        texte = file.readlines()
        file.close()

        self.name = texte[0].replace('\n','')
        self.min = int(texte[1].replace('\n',''))
        self.max = int(texte[2].replace('\n',''))
        self.isFixed = bool(texte[4].replace('\n',''))
        self.default = int(texte[5].replace('\n',''))
        self.currentValue = int(texte[6].replace('\n',''))

    def generateFileName(self, execOrAnalyse, prefixe, paramvariationList) :
        fileName = prefixe
        if execOrAnalyse == EXECUTION_ID :
            fileName = "execution_" + fileName
        elif execOrAnalyse == COMPLEXITY_ANALYSIS_ID :
            fileName = "complexity_theoretical_analysis_" + fileName
        elif execOrAnalyse == MEMORY_ANALYSIS_ID :
            fileName = "memory_theoretical_analysis_" + fileName
        else :
            raise Exception("ParamVariation - generateGraph: execOrAnalyse > 4 (impossible).")

        for i in range(len(paramvariationList)) :
            fileName = fileName + "_" + paramvariationList[i].name
            if paramvariationList[i].isFixed :
                fileName = fileName + "_" + str(paramvariationList[i].default)
            else :
                fileName = fileName + "_" + str(paramvariationList[i].min)
                fileName = fileName + "_" + str(paramvariationList[i].max)
                fileName = fileName + "_" + str(paramvariationList[i].step)
        return fileName

    def __repr__(self):
        return "ParamVariation: name({}), min({}), max({}), step({}), isFixed({}), default({}), currentValue({})".format(
                self.name, self.min, self.max, self.step, self.isFixed, self.default, self.currentValue)

    def __eq__(self, currentValue) :
        if self.name == currentValue.name and self.min == currentValue.min and self.max == currentValue.max and self.step == currentValue.step and self.isFixed == currentValue.isFixed and self.default == currentValue.default :
            return True
        else :
            return False
