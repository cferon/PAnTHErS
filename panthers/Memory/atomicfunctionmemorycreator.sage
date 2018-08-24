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


class AtomicFunctionMemoryCreator(object):
    """ AtomicFunctionMemoryCreator allows creating AtomicFunctionMemory objects."""

    def __init__(self) :
        self.builder = Builder()
        self.operator = ObjectOperatorMemory()

    def make_all(self) :
        res = []
        res = res + [self.make_add()]
        res = res + [self.make_sub()]
        res = res + [self.make_mult()]
        res = res + [self.make_mod()]
        res = res + [self.make_rand()]
        res = res + [self.make_prodScal()]
        res = res + [self.make_div()]
        res = res + [self.make_round()]
        res = res + [self.make_digits()]
        res = res + [self.make_pow()]
        res = res + [self.make_inv()]
        return res

    def make_add(self) :
        """ AtomicFunctionMemory addition of Parameters"""
        atom = self.builder.atomicFunctionMemory("add")

        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomAdd"+atom.count.str(),"NoType",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            rowsX = x.rows
            rowsY = y.rows
            colsX = x.cols
            colsY = y.cols

            if rowsX == colsY and colsX == rowsY :
                if rowsX != 1 or colsX != 1 :
                    y.rows = colsY
                    y.cols = rowsY

            outputs[0] = self.operator.add(x,y,outputs[0], memory)

            atom.outputs = outputs

            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_sub(self) :
        """ AtomicFunctionMemory subtraction of Parameters"""
        atom = self.builder.atomicFunctionMemory("sub")

        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomSub"+atom.count.str(),"NoType",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            outputs[0] = self.operator.sub(x,y,outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_mult(self) :
        """ AtomicFunctionMemory multiplication of Parameters"""
        atom = self.builder.atomicFunctionMemory("mult")

        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomMult"+atom.count.str(),"NoType",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            outputs[0] = self.operator.mult(x,y,outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_mod(self) :
        """ AtomicFunctionMemory modulo for Parameter"""
        atom = self.builder.atomicFunctionMemory("mod")

        #y Parameter is of type "int" ou "poly" only.
        #z Parameter has the same type of x Parameter.
        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomMod"+atom.count.str(),"NoType",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            outputs[0] = self.operator.mod(x,y,outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_rand(self) :
        """ AtomicFunctionMemory random """
        atom = self.builder.atomicFunctionMemory("rand")

        rows = self.builder.parameter("rows","int",0,1,1) #int
        cols = self.builder.parameter("cols","int",0,1,1) #int
        degree = self.builder.parameter("degree","int",0,1,1) #int

        atom.inputs = [rows, cols, degree]
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomRand"+atom.count.str(),"NoType",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [rows, cols, degree] = atom.inputs

            if len(sets) == 1 :
                outputs[0] = self.operator.rand(rows, cols, sets[0], degree, outputs[0], 0)
            else :
                outputs[0] = self.operator.rand(rows, cols, sets[0], degree, outputs[0], sets[1])

            atom.outputs = [outputs[0]]
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_prodScal(self) :
        """ AtomicFunctionMemory dot product of Parameters """
        atom = self.builder.atomicFunctionMemory("prodScal")

        #x and y Parameter has the same dimensions (n*1) and are of type "matrix" or "matrixPoly
        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomProdScal"+atom.count.str(),"NoType",0,1,1)] #int ou poly
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.parameter(outputs[0])

            rowsX = x.rows
            rowsY = y.rows
            colsX = x.cols
            colsY = y.cols

            if rowsX == rowsY and colsX == colsY :
                y.rows = colsY
                y.cols = rowsY
                colsY = y.cols
                rowsY = y.rows

            if not(rowsX == colsY and rowsY == colsX) :
                raise Exception("ProdScal: the two vectors do not have the same dimensions.")

            outputs[0] = self.operator.mult(x,y,outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_div(self) :
        """ AtomicFunctionMemory division of Parameters (of type "int" and "float")"""
        atom = self.builder.atomicFunctionMemory("div")

        # x et y are of type "int" ou "float"
        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomDiv"+atom.count.str(),"float",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"float",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            outputs[0] = self.operator.div(x,y,outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_round(self) :
        """ AtomicFunctionMemory round of Parameters (of type "float")"""
        atom = self.builder.atomicFunctionMemory("round")

        inputs = [self.builder.parameter("x","NoType",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomRound"+atom.count.str(),"NoType",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x] = atom.inputs

            outputs[0] = self.operator.round(x,outputs[0], memory)
            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_digits(self) :
        """ AtomicFunctionMemory digits of Parameters (of type "int" and "poly")
            Does a binary decomposition of int or poly. Put decomposition into a matrix. """
        atom = self.builder.atomicFunctionMemory("digits")

        #x = int or poly
        inputs = [self.builder.parameter("x","NoType",0,1,1),self.builder.parameter("w","int",0,1,1),self.builder.parameter("l","int",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomDigits"+atom.count.str(),"NoType",0,1,1)] #list or matrix
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x,w,l] = atom.inputs

            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.parameter(outputs[0])

            if x.type == "int" :
                outputs[0].type = "matrix"
                outputs[0].rows = 1
                outputs[0].cols = l.value
                outputs[0].degree = 0
            elif x.type == "poly" :
                outputs[0].type = "matrix"
                outputs[0].rows = l.value
                outputs[0].cols = x.degree + 1
                outputs[0].degree = 0
            else :
                raise Exception("Digits: first Parameter is not of type int or poly but of type {}".format(x.type))

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_pow(self) :
        """ AtomicFunctionMemory pow of Parameters (of type "int")"""
        atom = self.builder.atomicFunctionMemory("pow")

        inputs = [self.builder.parameter("x","int",0,1,1), self.builder.parameter("y","int",0,1,1)]
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs,count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomPow"+atom.count.str(),"int",0,1,1)]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"int",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs, count)
            atom.inputs = inputs
            [x, y] = atom.inputs

            outputs[0] = self.operator.pow(x,y,outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom

    def make_inv(self) :
        """ AtomicFunctionMemory inverse of Parameters (of type "int" and "poly")
            Returns inverse of x in R (if x integer), the inverse of x mod y in R (if x poly)."""
        atom = self.builder.atomicFunctionMemory("inv")

        inputs = [self.builder.parameter("x","NoType",0,1,1), self.builder.parameter("y","NoType",0,1,1)] #x,y = int or poly
        atom.inputs = inputs
        atom.memory = Memory()

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutAtomInv_" + atom.count.str(),"NoType",0,1,1)] #int or poly
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], memory = atom.memory, count = atom.count) :
            outputs = check_outputs(outputs,count)
            atom.inputs = inputs
            [x,y] = atom.inputs
            [R] = sets

            outputs[0] = self.operator.inv(x, y, R, outputs[0], memory)

            atom.outputs = outputs
            memory.sortAtom(atom, atom.name + " : ")
            return atom.outputs

        atom.ope = ope

        return atom
