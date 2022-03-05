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
from PIL import ImageTk

class GraphInterface :

    def __init__(self, name) :
        self.graphFrame = Toplevel()
        self.graphFrame.title(name)
        self.__name = name
        self.graphLabel = Label(self.graphFrame, text=name, font="Calibri 10 bold")
        self.photoGraph = PhotoImage(file="Res/Graphs/" + name+".png")
        self.message = Label(self.graphFrame, image=self.photoGraph)
        self.message.image = self.photoGraph

    @property
    def graphFrame(self) :
        return self.__graphFrame

    @graphFrame.setter
    def graphFrame(self, graphFrame) :
        self.__graphFrame = graphFrame

    @property
    def name(self) :
        return self.__name

    @name.setter
    def name(self, name) :
        self.__name = name

    def show(self) :
        self.message.grid(row=0, column=2, columnspan=2, sticky=W+E+N+S)
