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


from sage.stats.distributions.discrete_gaussian_lattice import DiscreteGaussianDistributionLatticeSampler

class ObjectOperatorMemory(object) :
    """Class gathering functions of about memory cost produced by operations between Parameter having different types. """

    def __init__(self) :
        self.builder = Builder()

    def isPowerOfTwo(self, x) :
        return (x != 0) and ((x & (-x)) == x)

    def updateReduceMemory(self, listInParams, outParam, memory) :
        for param in listInParams :
            if param == outParam :
                memory.reduce_memTmp(param)

    def updateRaiseMemory(self, listInParams, outParam, memory) :
        for param in listInParams :
            if param == outParam :
                memory.raise_memTmp(param)

    def add(self, inParam1, inParam2, outParam, memory) :
        """ inParam1, inParam2: Parameter, outParam: String or Parameter
            Return a Parameter having a value containing addition of inParam1 and inParam2 values.
            inParam1 and inParam2 must have the same type except if float + int or int + float."""

        type1 = inParam1.type
        type2 = inParam2.type
        nrows1 = inParam1.rows
        ncols1 = inParam1.cols
        deg1 = inParam1.degree
        deg2 = inParam2.degree

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type1 == type2 :
            outParam.type = type1
        elif (type1 == "int" and type2 == "float") or (type2 == "int" and type1 == "float") :
            outParam.type = "float"
        elif (type1 == "int" and type2 == "poly") or (type2 == "int" and type1 == "poly") :
            outParam.type = "poly"
        elif (type1 == "matrix" and type2 == "matrixPoly") or (type2 == "matrix" and type1 == "matrixPoly") :
            outParam.type = "matrixPoly"
        else :
            raise Exception("Add: Impossible to add Parameter {} of type {} with Parameter {} of type {}".format(inParam1.name, type1,
                    inParam2.name, type2))

        outParam.rows = nrows1
        outParam.cols = ncols1
        outParam.degree = max(deg1,deg2)

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam

    def sub(self, inParam1, inParam2, outParam, memory) :
        """ inParam1, inParam2: Parameter, outParam: String or Parameter
            Return a Parameter having a value containing subtraction of inParam1 and inParam2 values.
            inParam1 and inParam2 must have the same type except if float - int or int - float."""

        val1 = inParam1.value
        val2 = inParam2.value
        type1 = inParam1.type
        type2 = inParam2.type
        nrows1 = inParam1.rows
        ncols1 = inParam1.cols
        deg1 = inParam1.degree
        deg2 = inParam2.degree

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type1 == type2 :
            outParam.type = type1
        elif (type1 == "int" and type2 == "float") or (type2 == "int" and type1 == "float") :
            outParam.type = "float"
        elif type1 == "poly" or type2 == "poly" :
            outParam.type = "poly"
        elif (type1 == "matrix" and type2 == "matrixPoly") or (type2 == "matrix" and type1 == "matrixPoly") :
            outParam.type = "matrixPoly"
        else :
            raise Exception("Sub: Impossible to subtract Parameter {} of type {} with Parameter {} of type {}".format(inParam1.name, type1,
                    inParam2.name, type2))

        outParam.rows = nrows1
        outParam.cols = ncols1
        outParam.degree = max(deg1,deg2)

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam

    def mult(self, inParam1, inParam2, outParam, memory) :
        """ inParam1, inParam2: Parameter, outParam: String or Parameter
            Return a Parameter having a value containing multiplication of inParam1 and inParam2 values.
            Allows to do:
                - int * int
                - int * float
                - float * int
                - poly * poly
                - poly * int
                - int * poly
                - float * poly
                - matrix * matrix
                - int * matrix
                - poly * matrix """

        val1 = inParam1.value
        val2 = inParam2.value
        type1 = inParam1.type
        type2 = inParam2.type
        nrows1 = inParam1.rows
        nrows2 = inParam2.rows
        ncols1 = inParam1.cols
        ncols2 = inParam2.cols
        deg1 = inParam1.degree
        deg2 = inParam2.degree

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        # matrix * matrix, matrix * matrixPoly, matrixPoly * matrix, matrixPoly * matrix
        if (type1 == "matrix" or type1 == "matrixPoly") and (type2 == "matrix" or type2 == "matrixPoly") :
            outParam.rows = nrows1
            outParam.cols = ncols2
            if type1 == "matrixPoly" and type2 == "matrixPoly" :
                outParam.degree = deg1+deg2
            else :
                outParam.degree = max(deg1, deg2)
            if type1 == "matrix" and type2 == "matrix" :
                if nrows1 == ncols2 and nrows1 == 1 :
                    outParam.type = "int"
                else :
                    outParam.type = "matrix"
            else :
                if nrows1 == ncols2 and nrows1 == 1 :
                    outParam.type = "poly"
                else :
                    outParam.type = "matrixPoly"

        # matrix * int, matrixPoly * int, matrix * poly, matrixPoly * poly (Can not do:  matrix * float, matrixPoly * float)
        elif type1 == "matrix" or type1 == "matrixPoly" :
            outParam.rows = nrows1
            outParam.cols = ncols1
            outParam.type = type1
            outParam.degree = deg1 + deg2

        # int * matrix, int * matrixPoly, poly * matrix, poly * matrixPoly (Can not do:  float * matrix, float * matrixPoly)
        elif type2 == "matrix" or type2 == "matrixPoly" :
            outParam.rows = nrows2
            outParam.cols = ncols2
            outParam.degree = deg1+deg2
            if nrows2 == ncols2 and nrows2 == 1 :
                outParam.type = type1
            else :
                outParam.type = type2
        else :
            outParam.rows = nrows1 #=1
            outParam.cols = ncols1 #=1
            if type1 == "poly" and type2 == "poly" :
                outParam.degree = deg1+deg2
            else :
                outParam.degree = max(deg1, deg2)
            # poly * poly, int * poly, poly * int, float * poly, poly * float
            if val1 != 1 and val2 != 1 :
                if type1 == "poly" or type2 == "poly" :
                    outParam.type = "poly"
                # float * float, float * int, int * float, int * int
                elif (type1 == "int" or type1 == "float") and (type2 == "int" or type2 == "float") :
                    if type1 == "float" or type2 == "float" : # float * float, float * int, int * float
                        outParam.type = "float"
                    else : # int * int
                        outParam.type = "int"
                else :
                    raise Exception("Mult: Impossible to multiply Parameter {} of type {} with Parameter {} of type {}".format(inParam1.name, type1,
                                    inParam2.name, type2))
            elif val1 == 1 :
                outParam.type = type2
            else :
                outParam.type = type1

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam

    def mod(self, inParam1, inParam2, outParam, memory) :
        """ inParam1, inParam2: Parameter, outParam: String or Parameter
            Return a Parameter having a value containing inParam1 value mod inParam2 value.
            inParam2 must be a Parameter of type int or poly."""

        type1 = inParam1.type
        type2 = inParam2.type
        nrows = inParam1.rows
        ncols = inParam1.cols
        deg1 = inParam1.degree
        deg2 = inParam2.degree

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type2 == "int" or type2 == "poly" :
            outParam.rows = nrows
            outParam.cols = ncols
            outParam.type = type1
            if type2 == "poly" :
                outParam.degree = deg2
            else :
                outParam.degree = deg1
        else :
            raise Exception("Mod: Impossible to do a mod on Parameter {} of type {}".format(inParam1.name, type2))

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam

    def rand(self, rows, cols, set, degree, outParam, ifDistriGaussian = 0) :
        """ name, type: String, rows, cols: int, ifDistriGaussian,set: ring/field (of polynomials)
            outParam: String or Parameter
            Returns a Parameter having a value of set of dimensions rows * cols."""

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if isinstance(rows, Parameter) :
            rows = rows.value
        if isinstance(cols, Parameter) :
            cols = cols.value
        if isinstance(degree, Parameter) :
            degree = degree.value

        if rows == 1 and cols == 1 :
            if sage.rings.polynomial.polynomial_ring.is_PolynomialRing(set) or \
				isinstance(set, DiscreteGaussianDistributionPolynomialSampler) or isinstance(set, DiscreteGaussianDistributionLatticeSampler) or \
				sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(set) :
                outParam.type = "poly"
            else :
                outParam.type = "int"
        else :
            if sage.rings.polynomial.polynomial_ring.is_PolynomialRing(set) or \
				isinstance(set, DiscreteGaussianDistributionPolynomialSampler) or isinstance(set, DiscreteGaussianDistributionLatticeSampler) or \
				sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(set) :
                outParam.type = "matrixPoly"
            else :
                outParam.type = "matrix"

        outParam.rows = rows
        outParam.cols = cols
        outParam.degree = degree

        return outParam

    def div(self, inParam1, inParam2, outParam, memory) :
        """ inParam1, inParam2: Parameter, outParam: String or Parameter
            Returns a Parameter having a value containing division of inParam1 value by inParam2 value.
            Allows to do:
                - float / int
                - float / float
                - int / int
                - int / float
                - poly / int
                - poly / float"""

        type1 = inParam1.type
        type2 = inParam2.type
        nrows1 = inParam1.rows
        ncols1 = inParam1.cols
        deg1 = inParam1.degree
        deg2 = inParam2.degree

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type1 == "int" or type1 == "float" :
            outParam.type = "float"
        elif type1 == "poly" :
            outParam.type = "poly"
        else :
            raise Exception("Div: Impossible to divide Parameter {} of type {}".format(inParam1.name, type1))

        outParam.rows = nrows1
        outParam.cols = ncols1
        outParam.degree = deg1-deg2

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam

    def round(self, inParam, outParam, memory) :
        """ inParam: Parameter, outParam: String or Parameter
            Returns a Parameter having a value containing inParam value rounded.
            Allows to do:
                - round(float)"""

        type = inParam.type
        nrows = inParam.rows
        ncols = inParam.cols
        deg = inParam.degree

        self.updateReduceMemory([inParam], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type == "float" :
            outParam.rows = nrows
            outParam.cols = ncols
            outParam.type = "int"
            outParam.degree = deg
        elif type == "poly" :
            outParam.rows = nrows
            outParam.cols = ncols
            outParam.type = "poly"
            outParam.degree = deg
        else :
            raise Exception("Round: Impossible to round Parameter {} of type {}".format(inParam.name,type))

        self.updateRaiseMemory([inParam], outParam, memory)

        return outParam

    def pow(self, inParam1, inParam2, outParam, memory) :
        """ inParam1, inParam2: Parameter, outParam: String or Parameter
            Returns a Parameter having a value containing inParam1 value pow inParam2 value.
            Allows to do:
                - int ^ int """

        val1 = inParam1.value
        type1 = inParam1.type
        type2 = inParam2.type
        nrows1 = inParam1.rows
        ncols1 = inParam1.cols

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type1 != "int" and type2 != "int" :
            raise Exception("Pow: Impossible to do pow operation on Parameter {} of type {}".format(inParam1.name, type1))

        outParam.rows = nrows1
        outParam.cols = ncols1
        outParam.type = "int"
        outParam.degree = 0

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam

    def inv(self, inParam1, inParam2, inSet, outParam, memory) :
        """ inParam: Parameter, inSet : Set, outParam: String or Parameter
            Returns a Parameter having a value containing inverse of inParam value in inSet."""

        val = inParam1.value
        type = inParam1.type
        nrows = inParam1.rows
        ncols = inParam1.cols
        deg = inParam1.degree

        self.updateReduceMemory([inParam1, inParam2], outParam, memory)

        if not(isinstance(outParam, Parameter)) :
            outParam = self.builder.parameter(outParam)

        if type == "int" :
            outParam.type = type
            if isinstance(inSet, sage.rings.real_mpfr.RealField_class) : #if inSet == RR
                outParam.type = "float"
            outParam.degree = deg #= 0
        elif type == "poly" :
            outParam.type = type
            outParam.degree = deg #= 0
            if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(set) :
                outParam.degree = inSet.degree()
        else :
            raise Exception("Inv: Impossible to inverse Parameter {} of type {}".format(inParam1.name, type))

        outParam.rows = nrows #= 1
        outParam.cols = ncols #= 1

        self.updateRaiseMemory([inParam1, inParam2], outParam, memory)

        return outParam
