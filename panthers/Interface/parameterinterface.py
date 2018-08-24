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


from Tkinter import *

class ParameterInterface :

    def __init__(self, frame, name) :
        self.__frame = frame
        self.__name = name
        self.nameLabel = Label(frame, text=name + " =")
        self.to = Label(frame, text="to")
        self.by = Label(frame, text="by")
        self.defaultText = Label(frame, text="default:")
        self.minInt = IntVar()
        self.min = Entry(frame, textvariable=self.minInt, width=3)
        self.maxInt = IntVar()
        self.max = Entry(frame, textvariable=self.maxInt, width=4)
        self.stepInt = IntVar()
        self.step = Entry(frame, textvariable=self.stepInt, width=3)
        self.defaultInt = IntVar()
        self.default = Entry(frame, textvariable=self.defaultInt, width=3)
        self.hasToBeAnalyzed = False
        self.forDefaultButton = [0,0,0,0]

    def showVariation(self, nbOfRow) :
        nbOfCol = 1
        self.nameLabel.grid(column=nbOfCol+1, row=nbOfRow)
        self.min.grid(column=nbOfCol+2, row=nbOfRow)
        self.to.grid(column=nbOfCol+3, row=nbOfRow)
        self.max.grid(column=nbOfCol+4, row=nbOfRow)
        self.by.grid(column=nbOfCol+5, row=nbOfRow)
        self.step.grid(column=nbOfCol+6, row=nbOfRow)
        nbOfRow = nbOfRow + 1
        self.defaultText.grid(column=nbOfCol+1, row=nbOfRow)
        self.default.grid(column=nbOfCol+2, row=nbOfRow)

    @property
    def frame(self) :
        return self.__frame

    @frame.setter
    def frame(self, frame) :
        self.__frame = frame

    @property
    def name(self) :
        return self.__name

    @name.setter
    def name(self, name) :
        self.__name = name

    def forgetAll(self) :
        self.nameLabel.grid_forget()
        self.min.grid_forget()
        self.to.grid_forget()
        self.max.grid_forget()
        self.by.grid_forget()
        self.step.grid_forget()
        self.default.grid_forget()
        self.defaultText.grid_forget()

    def createParamVariation(self) :
        if self.hasToBeAnalyzed :
            return ParamVariation(self.name, self.minInt.get(), self.maxInt.get(), self.stepInt.get(), False, self.defaultInt.get())
        else :
            return ParamVariation(self.name, self.minInt.get(), self.maxInt.get(), self.stepInt.get(), True, self.defaultInt.get())
