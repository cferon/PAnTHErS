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


class Complexity(object):
    """Complexity objects are composed of:
        - dictionnary containing all numbers of operations performed depending on type of their input (int, int/poly, poly)
        - dictionnary corresponding to first dictionnary converted into number of operations performed on integers only."""

    def __init__(self, flag = "HEBasic", file = "") :
        self.__complexity = {"int":{"add":0, "mult":0, "sub":0, "rand":0, "round":0, "shiftD":0, "shiftG":0, "pow":0, "div":0, "mod":0}, \
        "int/poly":{"add":0, "mult":0, "sub":0, "shiftD":0, "shiftG":0, "pow":0, "div":0, "mod":0},\
        "poly":{"add":0, "mult":0, "sub":0, "rand":0, "round":0, "mod":0}}
        self.__complexMax = {"add":0, "mult":0, "sub":0, "rand":0, "round":0, "shiftD":0, "shiftG":0, "pow":0, "div":0, "mod":0}
        self.__file = file
        self.__flag = flag

    @property
    def complexity(self) :
        return self.__complexity

    @complexity.setter
    def complexity(self, complexity) :
        self.__complexity = complexity

    @property
    def complexMax(self) :
        return self.__complexMax

    @complexMax.setter
    def complexMax(self, complexMax) :
        self.__complexMax = complexMax

    @property
    def file(self) :
        return self.__file

    @file.setter
    def file(self, file) :
        self.__file = file

    @property
    def flag(self) :
        return self.__flag

    @flag.setter
    def flag(self, flag) :
        self.__flag = flag

    def __repr__(self):
        res = ""
        for a in self.complexity :
            for b in self.complexity[a] :
                if self.complexity[a][b] != 0 :
                    res = res + a + " - " + b + " : " + (self.complexity[a][b]).str() + "\n"
        return "Complexity: \n{}".format(res)

    def __getitem__(self,i):
        return self.complexity[i]

    def __add__(self, complex) :
        return self.add(complex)

    def printInFile(self, type, msg) :
        if isinstance(type, AtomicFunctionComplexity) and self.flag == "Atom" :
            if self.file == "terminal" :
                print(msg, self.convertToOneComplexity())
            elif self.file != "" :
                self.file.write(msg + self.convertToOneComplexity().str() + "\n")

        if isinstance(type, SpecificFunctionComplexity) and (self.flag == "Spec" or self.flag == "Atom") :
            if self.file == "terminal" :
                print(msg, self.convertToOneComplexity())
            elif self.file != "" :
                self.file.write(msg + self.convertToOneComplexity().str() + "\n")

        if isinstance(type, HEBasicFunctionComplexity) :
            if self.file == "terminal" :
                print(msg, self.convertToOneComplexity())
            elif self.file != "" :
                self.file.write(msg + self.convertToOneComplexity().str() + "\n")

    def reset(self) :
        self.complexity = {"int":{"add":0, "mult":0, "sub":0, "rand":0, "round":0, "shiftD":0, "shiftG":0, "pow":0, "div":0, "mod":0}, \
        "int/poly":{"add":0, "mult":0, "sub":0, "shiftD":0, "shiftG":0, "pow":0, "div":0, "mod":0},\
        "poly":{"add":0, "mult":0, "sub":0, "rand":0, "round":0, "mod":0}}

    def add(self, b) :
        res = Complexity()

        for key in res.complexity :
            for subkey in res[key] :
                res[key][subkey] = self.complexity[key][subkey] + b[key][subkey]

        for subkey in res.complexMax :
            res.complexMax[subkey] = self.complexMax[subkey] + b.complexMax[subkey]

        return res

    def convertToIntComplexity(self, d, algo) :

        res = {"add":0, "mult":0, "sub":0, "rand":0, "round":0, "shiftD":0, "shiftG":0, "pow":0, "div":0, "mod":0}

        for i in res :
            res[i] = self.complexity["int"][i]

        #int/poly case
        res["add"] = res["add"] + self.complexity["int/poly"]["add"]
        res["mult"] = res["mult"] + d*self.complexity["int/poly"]["mult"]
        res["sub"] = res["sub"] + self.complexity["int/poly"]["sub"]
        res["shiftD"] = res["shiftD"] + d*self.complexity["int/poly"]["shiftD"] # poly >> int only
        res["shiftG"] = res["shiftG"] + d*self.complexity["int/poly"]["shiftG"] # poly << int only
        res["div"] = res["div"] + d*self.complexity["int/poly"]["div"] + self.complexity["poly"]["mod"]
        res["mod"] = res["mod"] + d*self.complexity["int/poly"]["mod"] # poly % int only
        #a["int/poly"]["pow"], a["int/poly"]["round"], a["int/poly"]["rand"] do not exist

        #poly case
        res["add"] = res["add"] + d*self.complexity["poly"]["add"]
        res["sub"] = res["sub"] + d*self.complexity["poly"]["sub"] + d*self.complexity["poly"]["mod"]
        res["round"] = res["round"] + d*self.complexity["poly"]["round"]
        res["rand"] = res["rand"] + d*self.complexity["poly"]["rand"]

        if algo == "naif" :
            res["mult"] = res["mult"] + d*d*self.complexity["poly"]["mult"] + d*self.complexity["poly"]["mod"]
        elif algo == "karatsuba" :
            res["mult"] = res["mult"] + ceil(d^1.59, bits=1000)*self.complexity["poly"]["mult"] + d*self.complexity["poly"]["mod"]
        else : #FFT
            res["mult"] = res["mult"] + d*log(d*log(log(d)))*self.complexity["poly"]["mult"] + d*self.complexity["poly"]["mod"]

        #a["poly"]["pow"], a["poly"]["mod"], a["poly"]["div"], a["poly"]["shiftG"], a["poly"]["shiftD"]
        # do not exist

        return res

    def convertToOneComplexity(self) :
        #Previous values for ratios:
        #add    sub   mod  round  rand  div  shiftD shiftG pow
        #1.327 1.094 0.852 0.291 0.504 0.114 0.753 0.867 0.454 : Version 3
        #1.309 1.065 0.909 0.314 0.53  0.115 0.386 0.705 0.48  : Version 4 (cputime)
        #1.387 1.168 0.975 0.276 0.518 0.115 0.405 0.755 0.522 : Version 4 bis (time.time)

        comp = self.complexMax

        res = comp["mult"]
        res = res + ceil(comp["add"]/1.309, bits=1000)
        res = res + ceil(comp["sub"]/1.065, bits=1000)
        res = res + ceil(comp["mod"]/0.909, bits=1000)
        res = res + ceil(comp["round"]/0.314, bits=1000)
        res = res + ceil(comp["rand"]/0.53, bits=1000)
        res = res + ceil(comp["div"]/0.115, bits=1000)
        res = res + ceil(comp["shiftD"], bits=1000)
        res = res + ceil(comp["shiftG"], bits=1000)
        res = res + ceil(comp["pow"]/0.48, bits=1000)

        return res
