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


class Memory(object):
    """Memory objects are composed of:
        - list of inputs, outputs and temporary variables
        - dictionnary for actual Memory
        - dictionnary for maximal Memory reached"""

    def __init__(self, flag = "HEBasic", file = "", module = 0) :
        self.__allMem = []
        self.__module = module
        self.__tmp = {"Atom":[], "Spec":[], "HEBasic":[]} #keep Parameters objects
        self.__outputs = []
        self.__memTmp = {"int":0, "poly":0, "total":0} #keep nb of int and poly
        self.__memMax = {"int":0, "poly":0, "total":0} #keep nb of int and poly max reached
        self.__file = file
        self.__flag = flag
        self.builder = Builder()

    @property
    def file(self) :
        return self.__file

    @file.setter
    def file(self, file) :
        self.__file = file

    @property
    def module(self) :
        return self.__module

    @module.setter
    def module(self, module) :
        self.__module = module

    @property
    def flag(self) :
        return self.__flag

    @flag.setter
    def flag(self, flag) :
        self.__flag = flag

    @property
    def allMem(self) :
        return self.__allMem

    @allMem.setter
    def allMem(self, allMem) :
        self.__allMem = allMem

    @property
    def tmp(self) :
        return self.__tmp

    @tmp.setter
    def tmp(self, tmp) :
        self.__tmp = tmp

    @property
    def outputs(self) :
        return self.__outputs

    @outputs.setter
    def outputs(self, outputs) :
        self.__outputs = outputs

    @property
    def memTmp(self) :
        return self.__memTmp

    @memTmp.setter
    def memTmp(self, memTmp) :
        self.__memTmp = memTmp

    @property
    def memMax(self) :
        return self.__memMax

    @memMax.setter
    def memMax(self, memMax) :
        self.__memMax = memMax

    def __repr__(self) :
        resMem = ""
        if len(self.allMem) != 0 :
            resMem = resMem + "Memory : \n"
        for i in self.allMem :
            resMem = resMem + i.name + " : " + i.type + ", " + str(i.rows) + "x" + str(i.cols) + "\n"
        resTmp = ""
        for i in self.tmp :
            if len(self.tmp[i]) != 0 :
                resTmp = resTmp + "Memory tmp - " + i + " : \n"
            for j in self.tmp[i] :
                resTmp = resTmp  + j.name + " : " + j.type + ", " + str(j.rows) + "x" + str(j.cols) + "\n"
        resOut = ""
        if len(self.outputs) != 0 :
            resOut = resOut + "Memory Outputs : \n"
        for i in self.outputs :
            resOut = resOut + i.name + " : " + i.type + ", " + str(i.rows) + "x" + str(i.cols) + "\n"

        return "{}\n{}\n{}".format(resMem, resTmp, resOut)

    def __add__(self, mem) :
        res = Memory(self.flag, self.file)
        res.allMem = self.allMem + mem.allMem
        res.tmp = {"Atom": self.tmp["Atom"] + mem.tmp["Atom"], "Spec": self.tmp["Spec"] + mem.tmp["Spec"],"HEBasic": self.tmp["HEBasic"] + mem.tmp["HEBasic"]}
        res.memTmp = {"int":self.memTmp["int"] + mem.memTmp["int"], "poly":self.memTmp["poly"] + mem.memTmp["poly"], "total":self.memTmp["total"] + mem.memTmp["total"]}
        res.memMax = {"int":self.memMax["int"] + mem.memMax["int"], "poly":self.memMax["poly"] + mem.memMax["poly"], "total":self.memMax["total"] + mem.memMax["total"]}
        res.outputs = self.outputs + mem.outputs
        return res

    def __ne__(self, mem) :
        if not(isinstance(mem, Memory)) :
            return True
        for i in mem.allMem :
            if not(i in self.allMem) :
                return True
        for i in mem.outputs :
            if not(i in self.outputs) :
                return True
        for i in mem.tmp["Atom"] :
            if not(i in self.tmp["Atom"]) :
                return True
        for i in mem.tmp["Spec"] :
            if not(i in self.tmp["Spec"]) :
                return True
        for i in mem.tmp["HEBasic"] :
            if not(i in self.tmp["HEBasic"]) :
                return True
        return False

    def printInFile(self, type, msg) :
        tmpInt, tmpPoly, tmpTotal, tmpTotal32 = self.convertTmpInBase(self.module.value, self.flag, 32)

        if isinstance(type, AtomicFunctionMemory) and self.flag == "Atom" :
            if self.file == "terminal" :
                print(msg, tmpInt, tmpPoly, tmpTotal, tmpTotal32)
            elif self.file != "" :
                self.file.write(msg + str(tmpInt) + "\t" + str(tmpPoly) + "\t" + str(tmpTotal) + "\t" + str(tmpTotal32) + "\n")

        if isinstance(type, SpecificFunctionMemory) and (self.flag == "Spec" or self.flag == "Atom") :
            if self.file == "terminal" :
                print(msg, tmpInt, tmpPoly, tmpTotal, tmpTotal32)
            elif self.file != "" :
                self.file.write(msg + str(tmpInt) + "\t" + str(tmpPoly) + "\t" + str(tmpTotal) + "\t" + str(tmpTotal32) + "\n")

        if isinstance(type, HEBasicFunctionMemory) :
            if self.file == "terminal" :
                print(msg, tmpInt, tmpPoly, tmpTotal, tmpTotal32)
            elif self.file != "" :
                self.file.write(msg + str(tmpInt) + "\t" + str(tmpPoly) + "\t" + str(tmpTotal) + "\t" + str(tmpTotal32) + "\n")

    def reset(self, mem) :
        self.allMem = []
        self.tmp = {"Atom":[], "Spec":[], "HEBasic":[]}
        self.outputs = []
        self.memTmp = {"int":0, "poly":0, "total":0}
        self.memMax = {"int":0, "poly":0, "total":0}

        if mem != 0 :
            self.memTmp = mem.memTmp
            self.memMax = mem.memMax
            self.flag = mem.flag
            self.file = mem.file

    def add(self, b) :
        self.allMem = self.allMem + [self.builder.parameter(b.name, b.type, b.value, b.rows,b.cols)]

    def check_max(self) :
        if self.memTmp["int"] > self.memMax["int"] :
            self.memMax["int"] = self.memTmp["int"]
        if self.memTmp["poly"] > self.memMax["poly"] :
            self.memMax["poly"] = self.memTmp["poly"]
        if self.memTmp["total"] > self.memMax["total"] :
            self.memMax["total"] = self.memTmp["total"]

    def sortHEBasic(self, heBasic, msg, outputs) :
        # Put outputs in self.output and remove them from self.allMem
        for i in outputs :
            j = 0
            while j < len(self.allMem) and i != self.allMem[j]:
                j = j + 1
            if j >= len(self.allMem) :
                continue
            else :
                self.allMem.remove(i)
                self.outputs = self.outputs + [i]

        # Print in file total memory cost
        self.printInFile(heBasic, msg)

        # Only temporary variables are in self.allMem, so they are put in self.tmp
        for i in self.allMem :
            self.tmp["HEBasic"] = self.tmp["HEBasic"] + [i]
            self.reduce_memTmp(i)
            self.printInFile(heBasic, msg)

        self.allMem = []

    def sortSpec(self, spec, msg) :
        #outputs of Memory object of SpecificMemory are put in allMem of Memory object of HEBasicMemory
        #If output is already in allMem, then its values are modified.
        for i in spec.outputs :
            j = 0
            while j < len(self.allMem) and i != self.allMem[j] :
                j = j + 1
            if j >= len(self.allMem) :
                self.allMem = self.allMem + [i]
            else :
                self.reduce_memTmp(self.allMem[j])
                self.allMem[j].rows = i.rows
                self.allMem[j].cols = i.cols
                self.allMem[j].value = i.value
                self.allMem[j].type = i.type
                self.allMem[j].degree = i.degree
            self.raise_memTmp(i)

        self.printInFile(spec, msg)

        #Management of temporary variables
        for i in spec.memory.allMem :
            self.tmp["Spec"] = self.tmp["Spec"] + [i]
            self.allMem.remove(i)
            self.reduce_memTmp(i)
            self.printInFile(spec, msg)

        spec.memory.allMem = []

    def sortAtom(self, atom, msg) :
        #Outputs of Memory object of AtomMemory are put in self.allMem
        #if an output is already in self.allMem, then its values are modified
        for i in atom.outputs :
            j = 0
            while j < len(self.allMem) and i != self.allMem[j] :
                j = j + 1
            if j >= len(self.allMem) :
                self.allMem = self.allMem + [i]
            else :
                self.reduce_memTmp(self.allMem[j])
                self.allMem[j].rows = i.rows
                self.allMem[j].cols = i.cols
                self.allMem[j].value = i.value
                self.allMem[j].type = i.type
                self.allMem[j].degree = i.degree
            self.raise_memTmp(i)

        self.printInFile(atom, msg)

    def update(self, mem) :
        self.memTmp["int"] = mem.memTmp["int"]
        self.memTmp["poly"] = mem.memTmp["poly"]
        self.memTmp["total"] = mem.memTmp["total"]

        self.memMax["int"] = mem.memMax["int"]
        self.memMax["poly"] = mem.memMax["poly"]
        self.memMax["total"] = mem.memMax["total"]

    def raise_memTmp(self, i) :
        if i.type == "poly" or i.type == "matrixPoly" or i.type == "listPoly" :
            self.memTmp["poly"] = self.memTmp["poly"] + i.rows*i.cols
        else :
            self.memTmp["int"] = self.memTmp["int"] + i.rows*i.cols
        self.memTmp["total"] = self.memTmp["total"] + (i.degree+1)*i.rows*i.cols
        self.check_max()

    def reduce_memTmp(self, i) :
        if i.type == "poly" or i.type == "matrixPoly" or i.type == "listPoly" :
            self.memTmp["poly"] = self.memTmp["poly"] - i.rows*i.cols
        else :
            self.memTmp["int"] = self.memTmp["int"] - i.rows*i.cols
        self.memTmp["total"] = self.memTmp["total"] - (i.degree+1)*i.rows*i.cols
        self.check_max()

    def allParamsCreated(self, rank) :
        #rank = "outputs" or "HEBasic" or "Spec" or "Atom"
        countPoly = 0
        countInt = 0
        countTotal = 0

        for i in self.outputs :
            if i.type == "poly" or i.type == "matrixPoly" or i.type == "listPoly" :
                countPoly = countPoly + i.rows*i.cols
                countTotal += i.rows*i.cols*(i.degree+1)
            else :
                countInt = countInt + i.rows*i.cols
                countTotal += i.rows*i.cols

        if rank == "HEBasic" or rank == "Spec" or rank == "Atom" :
            for i in self.tmp["HEBasic"] :
                if i.type == "poly" or i.type == "matrixPoly" or i.type == "listPoly" :
                    countPoly = countPoly + i.rows*i.cols
                    countTotal += i.rows*i.cols*(i.degree+1)
                else :
                    countInt = countInt + i.rows*i.cols
                    countTotal += i.rows*i.cols

        if rank == "Spec" or rank == "Atom" :
            for i in self.tmp["Spec"] :
                if i.type == "poly" or i.type == "matrixPoly" or i.type == "listPoly" :
                    countPoly = countPoly + i.rows*i.cols
                    countTotal += i.rows*i.cols*(i.degree+1)
                else :
                    countInt = countInt + i.rows*i.cols
                    countTotal += i.rows*i.cols

        if rank == "Atom" :
            for i in self.tmp["Atom"] :
                if i.type == "poly" or i.type == "matrixPoly" or i.type == "listPoly" :
                    countPoly = countPoly + i.rows*i.cols
                    countTotal += i.rows*i.cols*(i.degree+1)
                else :
                    countInt = countInt + i.rows*i.cols
                    countTotal += i.rows*i.cols

        return countInt, countPoly, countTotal

    def convertTmpInBase(self, q, rank, base) :
        countTotal = floor(self.memTmp["total"]*log(q,2^base), bits=1000) + 1
        return self.memTmp["int"], self.memTmp["poly"], self.memTmp["total"], countTotal

    def convertInBase(self, q, rank, base) :
        countTotal = floor(self.memMax["total"]*log(q,2^base), bits=1000) + 1
        return self.memMax["int"], self.memMax["poly"], self.memMax["total"], countTotal
