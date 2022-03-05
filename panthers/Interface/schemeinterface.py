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


from tkinter import *
attach("../Interface/parameterinterface.py")

class SchemeInterface :

    def __init__(self, schemeFrame, paramFrame, name, idNumber, nbOfParams, paramNames, nbOfRow) :
        self.__schemeFrame = schemeFrame
        self.__paramFrame = paramFrame
        self.__name = name
        self.__idNumber = idNumber
        self.schemeLabel = Label(schemeFrame, text=name, font="Calibri 10 bold")
        self.paramLabel = Label(paramFrame, text=name, font="Calibri 10 bold")
        self.not_selected =  Label(paramFrame, text=self.name  + " not selected")
        self.not_selected.grid(row=nbOfRow, column=1, columnspan=7)
        self.__nbOfParams = nbOfParams
        self.__paramNames = paramNames
        self.is_checked = BooleanVar(schemeFrame, '0')
        self.checkButton = Checkbutton(schemeFrame, variable=self.is_checked, text=self.name, command=self.showParamsVariation)
        self.params = [ParameterInterface(paramFrame, paramNames[i]) for i in range(nbOfParams)]
        self.nbOfSchemeRow = nbOfRow

    def showParamsVariation(self) :
        nb = self.nbOfSchemeRow
        if self.is_checked.get() :
            self.not_selected.grid_forget()
            self.paramLabel.grid(column=1, row=nb)
            nb = nb + 1
            for param in self.params :
                param.showVariation(nb)
                nb = nb + 2
        else :
            self.not_selected.grid(row=nb, column=1, columnspan=7)
            self.paramLabel.grid_forget()
            nb = nb - 1
            for param in self.params :
                param.forgetAll()
                nb = nb - 2

    @property
    def schemeFrame(self) :
        return self.__schemeFrame

    @schemeFrame.setter
    def schemeFrame(self, schemeFrame) :
        self.__schemeFrame = schemeFrame

    @property
    def idNumber(self) :
        return self.__idNumber

    @idNumber.setter
    def idNumber(self, idNumber) :
        self.__idNumber = idNumber

    @property
    def paramFrame(self) :
        return self.__paramFrame

    @paramFrame.setter
    def paramFrame(self, paramFrame) :
        self.__paramFrame = paramFrame

    @property
    def name(self) :
        return self.__name

    @name.setter
    def name(self, name) :
        self.__name = name

    @property
    def paramNames(self) :
        return self.__paramNames

    @paramNames.setter
    def paramNames(self, paramNames) :
        self.__paramNames = paramNames

    @property
    def nbOfParams(self) :
        return self.__nbOfParams

    @nbOfParams.setter
    def nbOfParams(self, nbOfParams) :
        self.__nbOfParams = nbOfParams
