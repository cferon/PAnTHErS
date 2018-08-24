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


class HomomorphicObject(object) :
    """ Abstract class representing a homomorphic object having:
        - inputs (list)
        - outputs (list)
        - sets (list)"""

    def __init__(self, inputs = [], sets = [], flag = "HEBasic", file = "") :
        self.__inputs = inputs
        self.__outputs = []
        self.__tmp = []
        self.__sets = sets
        self.__flag = flag
        self.__file = file

    @property
    def inputs(self) :
        return self.__inputs

    @inputs.setter
    def inputs(self, inputs) :
        if (isinstance(self, SpecificFunction) or isinstance(self, AtomicFunction)) and len(self.__inputs) != 0 :
            if len(self.__inputs) > len(inputs) :
                raise Exception("HomomorphicObject: Miss {} Parameters in inputs of {}".format(len(self.__inputs)-len(inputs), self.name))
            if len(self.__inputs) < len(inputs) :
                raise Exception("HomomorphicObject: {} unwanted Parameters in inputs of {}".format(len(inputs)-len(self.__inputs), self.name))
            for i in range(len(self.__inputs)) :
                inputs[i] = self.verifyTypeInParam(inputs[i], self.__inputs[i].name)
        self.__inputs = inputs

    @property
    def outputs(self) :
        return self.__outputs

    @outputs.setter
    def outputs(self, outputs) :
        if (isinstance(self, SpecificFunction) or isinstance(self, AtomicFunction)) and len(self.__outputs) != 0 :
            for i in range(len(self.__outputs)) :
                if not(isinstance(self.__outputs[i], Parameter)) :
                    raise Exception("HomomorphicObject: Impossible to put another type than Parameter in outputs of {}".format(self.name))
        self.__outputs = outputs

    @property
    def tmp(self) :
        return self.__tmp

    @tmp.setter
    def tmp(self, tmp) :
        if (isinstance(self, SpecificFunction) or isinstance(self, AtomicFunction)) and len(self.__tmp) != 0 :
            for i in range(len(self.__tmp)) :
                if not(isinstance(self.__tmp[i], Parameter)) :
                    raise Exception("HomomorphicObject: Impossible to put another type than Parameter in tmp of {}".format(self.name))
        self.__tmp = tmp

    def get_input(self, name) :
        finder = Finder()
        return finder.parameter(self.inputs, name)

    def get_output(self, name) :
        finder = Finder()
        return finder.parameter(self.outputs, name)

    @property
    def sets(self) :
        return self.__sets

    @sets.setter
    def sets(self, sets) :
        self.__sets = sets

    @property
    def flag(self) :
        return self.__flag

    @flag.setter
    def flag(self, flag) :
        self.__flag = flag

    @property
    def file(self) :
        return self.__file

    @file.setter
    def file(self, file) :
        self.__file = file

    def verifyTypeInParam(self, inParam, name) :
        """If inParam is not a Parameter, this function changes it in a Parameter object."""
        builder = Builder()

        if isinstance(inParam, Integer) or isinstance(inParam, int) :
            inParam = builder.parameter(name, "int", inParam, 1,1)
        elif isinstance(inParam, float) :
            inParam = builder.parameter(name, "float", inParam, 1,1)
        elif isinstance(inParam, sage.rings.polynomial.all.Polynomial) or isinstance(inParam, sage.rings.polynomial.all.PolynomialQuotientRingElement) :
            inParam = builder.parameter(name, "poly", inParam, 1,1)
        elif isinstance(inParam, sage.matrix.matrix_integer_dense.Matrix_integer_dense) :
            inParam = builder.parameter(name, "matrix", inParam, inParam.nrows(),inParam.ncols())
        elif isinstance(inParam, sage.matrix.matrix_generic_dense.Matrix_generic_dense) :
            inParam = builder.parameter(name, "matrixPoly", inParam, inParam.nrows(),inParam.ncols())
        elif not(isinstance(inParam, Parameter)) :
            raise Exception("HomomorphicObject: {} type of input is not = int, float, poly, matrix or Parameter".format(type(inParam)))

        return inParam

    def __repr__(self):
        return "HomomorphicObject: number of inputs ({}), number of outputs ({})".format(
                len(self.__inputs), len(self.__outputs))

    def printInFile(self, type, msg) :
        if isinstance(type, AtomicFunction) and self.flag == "Atom" :
            if self.file == "terminal" :
                print(self.name + " " + msg)
            elif self.file != "" :
                self.file.write(self.name + " " + msg + "\n")

        if isinstance(type, SpecificFunction) and (self.flag == "Spec" or self.flag == "Atom") :
            if self.file == "terminal" :
                print(self.name + " " + msg)
            elif self.file != "" :
                self.file.write(self.name + " " + msg + "\n")

        if isinstance(type, HEBasicFunction) :
            if self.file == "terminal" :
                print(self.name + " " + msg)
            elif self.file != "" :
                self.file.write(msg + "\n")
