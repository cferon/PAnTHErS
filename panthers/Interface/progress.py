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


from functools import partial
from Tkinter import *
import ttk
from ttk import *

class Progress :
    """Display a progress bar"""

    def __init__(self, frame, name, length):
        self.__frame = frame
        self.__name = name
        self.__length = length
        self.prefixeLabel = ""
        self.labelProgress = Style(frame)
        self.labelProgress.layout(name,
                 [(self.name+'.trough',
                   {'children': [(self.name+'.pbar',
                                  {'side': 'left', 'sticky': 'ns'}),
                                 (self.name+".label",
                                  {"sticky": ""})],
                   'sticky': 'nswe'})])
        self.labelProgress.configure(name, background="lightblue")
        self.progressBar = ttk.Progressbar(frame, style=name, length=length, orient='horizontal', mode='determinate')

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

    @property
    def length(self) :
        return self.__length

    @length.setter
    def length(self, length) :
        self.__length = length

    def updateProgress(self, stepProgess) :
        self.progressBar.step(stepProgess)
        self.progressBar.update_idletasks()

    def grid_forget(self) :
        self.progressBar.grid_forget()

    def grid(self, row = 0, column = 0) :
        self.progressBar.grid(row=row, column=column)

    def update_idletasks(self) :
        self.progressBar.update_idletasks()

    def configure(self, text) :
        self.labelProgress.configure(self.name, text=self.prefixeLabel + text)
        self.progressBar.update_idletasks()

    def findPrefixeProgressBarLabel(self, scheme, paramsIn) :
        if scheme == 0 :
            scheme = "FV"
        elif scheme == 1 :
            scheme = "YASHE"
        elif scheme == 2 :
            scheme = "FNTRU"
        else :
            scheme = "Ghost Scheme"

        for param in paramsIn :
            if not(param.isFixed) :
                self.prefixe = "PAnTHErS "+ scheme + ": " + param.name + " "
