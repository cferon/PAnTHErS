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


import time

class SpecificFunctionCreator(object):
    """ SpecificFunctionCreator allows creating SpecificFunction objects."""

    def __init__(self, flag = "HEBasic", file = "") :
        self.builder = Builder()
        self.operator = ObjectOperator()
        self.finder = Finder()
        self.__flag = flag
        self.__file = file
        self.atomicfunctioncreator = AtomicFunctionCreator(flag, file)
        self.allAtomics = self.atomicfunctioncreator.make_all()

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

    def make_all(self) :
        res = []
        res = res + [self.make_addTimes()]
        res = res + [self.make_distriLWE()]
        res = res + [self.make_doubleDistriLWE()]
        res = res + [self.make_doubleMod()]
        res = res + [self.make_prodScalMod()]
        res = res + [self.make_pubKeyGen()]
        res = res + [self.make_changeMod()]
        res = res + [self.make_wordDecomp()]
        res = res + [self.make_prodOfAdd()]
        res = res + [self.make_powersOf()]
        res = res + [self.make_doubleMultInv()]
        res = res + [self.make_randMultMod()]
        res = res + [self.make_wordDecompInv()]
        res = res + [self.make_flatten()]
        res = res + [self.make_msbToPolynomial()]
        res = res + [self.make_modCenterInZero()]
        return res

    def changeRing(self,p,R) :
        if isinstance(p, Parameter) :
            p.value = R(list(p.value))
            return p
        else :
            return R(list(p))

    def changeMatrixRing(self,M,R) :
        if isinstance(M, Parameter) :
            p = M.value
        else :
            p = M

        A = []
        for i in range(M.rows) :
            B = []
            for j in range(M.cols) :
                a = p[i][j]
                if isinstance(a,PolynomialQuotientRingElement) :
                    B = B + [self.changeRing(a,R)]
                else :
                    B = B + [R(a)]
            A = A + [B]
        p = A

        M.value = matrix(R,p)
        return M

    def make_addTimes(self) :
        """ SpecificFunction addTimes: d = a + b * c"""
        spec = self.builder.specificFunction("addTimes", self.flag, self.file)

        inputs = [self.builder.parameter("a","NoType",0,1,1), self.builder.parameter("b","NoType",0,1,1), self.builder.parameter("c","NoType",0,1,1)]
        spec.inputs = inputs

        add = self.finder.atomic(self.allAtomics, "add")
        mult = self.finder.atomic(self.allAtomics, "mult")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecAddTimes_" + spec.count.str(),"NoType",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], sets = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [a,b,c] = spec.inputs

            [tmp] = mult.ope([b,c], ["TmpSpecAddTimes_" + spec.count.str()])
            [outputs[0]] = add.ope([a,tmp], [outputs[0]])

            if len(sets) != 0 :
                R = sets[0]
                if outputs[0].type == "matrix" or outputs[0].type == "matrixPoly":
                    outputs[0].value = matrix(R, outputs[0].value)
                else : #int ou poly
                    outputs[0].value = R(outputs[0].value)
                if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(R) :
                    outputs[0].degree = R.degree()

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_distriLWE(self) :
        """ SpecificFunction distriLWE (inputs: R, X, n, m, s, k, d, outputs: b, A):
                A <-- random matrix in R_q of dimensions n*m (d: degree of elements in A and e)
                e <-- random vector in X of size n
                b <-- (A*s+k*e) mod q"""
        spec = self.builder.specificFunction("distriLWE", self.flag, self.file)

        n = self.builder.parameter("n","int",0,1,1)
        m = self.builder.parameter("m","int",0,1,1)
        k = self.builder.parameter("k","int",0,1,1)
        d = self.builder.parameter("d","int",0,1,1)
        s = self.builder.parameter("s","NoType",0,1,1)
        q = self.builder.parameter("q","int",0,1,1)
        inputs = [n,m,k,d,s,q]

        spec.inputs = inputs

        rand = self.finder.atomic(self.allAtomics, "rand")
        mod = self.finder.atomic(self.allAtomics, "mod")
        mult = self.finder.atomic(self.allAtomics, "mult")
        add = self.finder.atomic(self.allAtomics, "add")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                b = self.builder.parameter("OutSpecDistriLWE_b_" + spec.count.str(),"NoType",0,m,1) #matrix or matrixPoly
                A = self.builder.parameter("OutSpecDistriLWE_A_" + spec.count.str(),"NoType",0,m,n) #matrix or matrixPoly
                outputs = [b,A]
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,m,1)
                if isinstance(outputs[1], str) :
                    outputs[1] = self.builder.parameter(outputs[1],"NoType",0,m,n)
                return outputs

        def ope(inputs, sets, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [n,m,k,d,s,q] = spec.inputs
            [b,A] = outputs
            if len(sets) == 3 :
                [R, X1, X2] = sets
            elif len(sets) == 2 :
                [R, X1] = sets

            if len(sets) == 3 :
                [A] = rand.ope([n,m,d], [X2, R], [A])
                [A] = mod.ope([A, q], [A])
            elif len(sets) == 2 :
                [A] = rand.ope([n,m,d], [R], [A])
                [A] = mod.ope([A, q], [A])
            [e] = rand.ope([n,1,d], [X1, R], ["TmpSpecDistriLWE_" + spec.count.str()])

            spec.count = spec.count + 1

            [outputs[0]] = mult.ope([A,s], [outputs[0]])
            [e] = mult.ope([k,e], [e])
            [outputs[0]] = add.ope([outputs[0],e], [outputs[0]])

            outputs[1] = A

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_doubleDistriLWE(self) :
        """ SpecificFunction doubleDistriLWE (inputs: Rq, Rp, X, n, m, d, s1, s2, outputs: b1, b2):
                A <-- random matrix in R_p of dimensions m*n (d: degree of elements in A, e1 and e2)
                e1 <-- random vector in X of size m
                e2 <-- random vector in X of size m
                b1 <-- (A*s1 + e1) mod q (dans Rq)
                b2 <-- (A*s2 + e2) mod q (dans Rq)"""
        spec = self.builder.specificFunction("doubleDistriLWE", self.flag, self.file)

        n = self.builder.parameter("n","int",0,1,1)
        m = self.builder.parameter("m","int",0,1,1)
        d = self.builder.parameter("d","int",0,1,1)
        s1 = self.builder.parameter("s1","matrixOrMatrixPoly",0,m,1)
        s2 = self.builder.parameter("s2","matrixOrMatrixPoly",0,m,1)
        inputs = [n,m,d,s1,s2]

        spec.inputs = inputs

        rand = self.finder.atomic(self.allAtomics, "rand")
        addTimes = self.make_addTimes()

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                b1 = self.builder.parameter("OutSpecDoubleDistriLWE_b1_" + spec.count.str(),"NoType",0,m,1) #matrix or matrixPoly
                b2 = self.builder.parameter("OutSpecDoubleDistriLWE_b2_" + spec.count.str(),"NoType",0,m,1) #matrix or matrixPoly
                outputs = [b1,b2]
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,m,1)
                if isinstance(outputs[1], str) :
                    outputs[1] = self.builder.parameter(outputs[1],"NoType",0,m,1)
                return outputs

        def ope(inputs, sets, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [n,m,d,s1,s2] = spec.inputs
            [b1,b2] = outputs
            [Rp,Rq,X] = sets

            [A] = rand.ope([n,m,d], [Rp, Rq], ["TmpSpecDoubleDistriLWE_A_" + spec.count.str()])
            [e1] = rand.ope([n,1,d], [X, Rq], ["TmpSpecDoubleDistriLWE_e1_" + spec.count.str()])
            [e2] = rand.ope([n,1,d], [X, Rq], ["TmpSpecDoubleDistriLWE_e2_" + spec.count.str()])
            spec.count = spec.count + 1

            [b1] = addTimes.ope([e1,A,s1], [b1], [Rq])
            [b2] = addTimes.ope([e2,A,s2], [b2], [Rq])

            spec.outputs = [b1,b2]
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_doubleMod(self) :
        """ SpecificFunction doubleMod (inputs: a,p,q, outputs: m):
                m <-- (a mod p) mod q
            p and q must be Parameters of type int or poly."""
        spec = self.builder.specificFunction("doubleMod", self.flag, self.file)

        a = self.builder.parameter("a","NoType",0,1,1)
        p = self.builder.parameter("p","intOrPoly",0,1,1)
        q = self.builder.parameter("q","intOrPoly",0,1,1)
        inputs = [a,p,q]

        spec.inputs = inputs

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                m = self.builder.parameter("OutSpecDoubleMod_" + spec.count.str(),"NoType",0,1,1)
                spec.count = spec.count + 1
                outputs = [m]
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [a,p,q] = spec.inputs

            outputs[0] = a%p
            outputs[0] = outputs[0]%q

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_prodScalMod(self) :
        """ SpecificFunction prodScalMod (inputs: a,b,p,q, outputs: m):
                m <-- <a,b> (dot product of a and b)
                m <-- (m mod p) mod q (doubleMod)
            a and b are vectors of same size."""
        spec = self.builder.specificFunction("prodScalMod", self.flag, self.file)

        a = self.builder.parameter("a","matrix",0,1,1)
        b = self.builder.parameter("b","matrix",0,1,1)
        p = self.builder.parameter("p","intOrPoly",0,1,1)
        q = self.builder.parameter("q","intOrPoly",0,1,1)
        inputs = [a,b,p,q]

        spec.inputs = inputs

        prodScal = self.finder.atomic(self.allAtomics, "prodScal")
        doubleMod = self.make_doubleMod()

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                m = self.builder.parameter("OutSpecProdScalMod_" + spec.count.str(),"NoType",0,1,1) #int or poly
                spec.count = spec.count + 1
                outputs = [m]
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [a,b,p,q] = spec.inputs
            [m] = outputs

            [m] = prodScal.ope([a,b],[m])
            spec.outputs = doubleMod.ope([m,p,q],[m])
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_pubKeyGen(self) :
        """ SpecificFunction pubKeyGen (inputs: k,b,A, outputs: P):
                P <-- b || k.A
            with k integer and || concatenation """
        spec = self.builder.specificFunction("pubKeyGen", self.flag, self.file)

        inputs = [self.builder.parameter("k","int",0,1,1), self.builder.parameter("b","NoType",0,8,1), self.builder.parameter("A","NoType",0,2,8)]
        spec.inputs = inputs

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecPubKeyGen_" + spec.count.str(),"NoType",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], sets = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [k,b,A] = spec.inputs

            outputs[0] = k*A
            outputs[0].value = block_matrix(1,2,[b.value, outputs[0].value])
            outputs[0].cols = b.cols + A.cols

            if len(sets) != 0 :
                R = sets[0]
                if outputs[0].type == "matrix" :
                    outputs[0].value = matrix(R, outputs[0].value)
                else : #int ou poly
                    outputs[0].value = R(outputs[0].value)
                if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(R) :
                    outputs[0].degree = R.degree()

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_changeMod(self) :
        """ SpecificFunction changeMod (inputs: q,p,t,m):
            Returns round((t/q) * m) mod p """
        spec = self.builder.specificFunction("changeMod", self.flag, self.file)

        q = self.builder.parameter("q","int",0,1,1)
        p = self.builder.parameter("p","int",0,1,1)
        t = self.builder.parameter("t","int",0,1,1)
        m = self.builder.parameter("m","NoType",0,1,1) #int or poly
        inputs = [q,p,t,m]

        spec.inputs = inputs

        div = self.finder.atomic(self.allAtomics, "div")
        mod = self.finder.atomic(self.allAtomics, "mod")
        mult = self.finder.atomic(self.allAtomics, "mult")
        round = self.finder.atomic(self.allAtomics, "round")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecChangeMod_" + spec.count.str(),"NoType",0,1,1)] #int or poly
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [q,p,t,m] = spec.inputs
            R = m.value.parent()

            [outputs[0]] = mult.ope([m,t], [outputs[0]])
            [outputs[0]] = div.ope([outputs[0],q], [outputs[0]])
            [outputs[0]] = round.ope([outputs[0]], [outputs[0]])
            outputs[0] = self.changeRing(outputs[0],R)
            [outputs[0]] = mod.ope([outputs[0],p], [outputs[0]])

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_modCenterInZero(self) :
        """ SpecificFunction modCenterInZero (inputs: p,q):
            Returns a = p mod q
            with -q/2 < a < q/2 """
        spec = self.builder.specificFunction("modCenterInZero", self.flag, self.file)

        p = self.builder.parameter("p","NoType",0,1,1) #no float
        q = self.builder.parameter("q","int",0,1,1)
        inputs = [p,q]

        spec.inputs = inputs

        sub = self.finder.atomic(self.allAtomics, "sub")
        add = self.finder.atomic(self.allAtomics, "add")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecModCenterInZero_" + spec.count.str(),"NoType",0,1,1)] #int or poly
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [p,q] = spec.inputs

            if p.type == "matrix" :
                for i in range(p.rows) :
                    for j in range(p.cols) :
                        if p.value[i][j] < -((q.value-1)/2) :
                            [tmp] = add.ope([p.value[i][j],q], ["TmpSpecModCenterInZero_" + spec.count.str()])
                            p.value[i][j] = tmp.value
                        if p.value[i][j] > ((q.value-1)/2) :
                            [tmp] = sub.ope([p.value[i][j],q], ["TmpSpecModCenterInZero_" + spec.count.str()])
                            p.value[i][j] = tmp.value

            elif p.type == "matrixPoly" :
                M = []
                for i in range(p.rows) :
                    N = []
                    for j in range(p.cols) :
                        L = list(p.value[i][j])
                        R = p.value[i][j].parent()
                        for k in range(len(L)) :
                            if L[k] < -((q.value-1)/2) :
                                [tmp] = add.ope([L[k],q], ["TmpSpecModCenterInZero_" + spec.count.str()])
                                L[k] = tmp.value
                            if L[k] > ((q.value-1)/2) :
                                [tmp] = sub.ope([L[k],q], ["TmpSpecModCenterInZero_" + spec.count.str()])
                                L[k] = tmp.value
                        N = N + [R(L)]
                    M = M + [N]
                p.value = matrix(R, M)

            elif p.type == "int" :
                if p.value < -((q.value-1)/2) :
                    [p] = add.ope([p,q], [p])
                if p.value > ((q.value-1)/2) :
                    [p] = sub.ope([p,q], [p])

            elif p.type == "poly" :
                L = list(p.value)
                R = p.value.parent()
                for i in range(len(L)) :
                    if L[i] < -((q.value-1)/2) :
                        [tmp] = add.ope([L[i],q], ["TmpSpecModCenterInZero_" + spec.count.str()])
                        L[i] = tmp.value
                    if L[i] > ((q.value-1)/2) :
                        [tmp] = sub.ope([L[i],q], ["TmpSpecModCenterInZero_" + spec.count.str()])
                        L[i] = tmp.value
                p.value = R(L)

            else :
                raise Exception("modCenterInZero: first Parameter has not the type = matrixPoly, poly, int, matrix but {}".format(p.type))

            outputs[0].rows = p.rows
            outputs[0].cols = p.cols
            outputs[0].degree = p.degree

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_wordDecomp(self) :
        """ SpecificFunction wordDecomp (inputs: x,w,q, outputs: L):
                Decompose coefficients of x in base w"""

        spec = self.builder.specificFunction("wordDecomp", self.flag, self.file)

        inputs = [self.builder.parameter("x","poly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs

        digits = self.finder.atomic(self.allAtomics, "digits")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecWordDecomp_" + spec.count.str(),"matrixPoly",0,1,1)]
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"matrixPoly",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [x,w,q] = spec.inputs

            nb = 1
            if x.type == "matrixPoly" :
                nb = x.rows
                R = x.value[0][0].parent()
            else :
                R = x.value.parent()

            qlen = self.builder.parameter("TmpSpecWordDecomp_qlen_" + spec.count.str(), "int", floor(log(q.value,w.value), bits=1000) + 1,1,1,0)
            spec.count = spec.count + 1

            lValue = []

            for j in range(nb) :
                lValueTmp = []

                for k in range(x.cols) :
                    if x.type == "matrixPoly" :
                        xTmp = self.builder.parameter(outputs[0].name + "_" + nb.str(), "poly", x.value[j,k],1,1,x.degree)
                    else :
                        xTmp = x

                    [L] = digits.ope([xTmp,w,qlen],["TmpSpecWordDecomp_L_" + spec.count.str()])

                    for i in range(L.rows) :
                        lValueTmp = lValueTmp + [R(list(L.value[i]))]

                lValue = lValue + [lValueTmp]

            outputs[0].value = matrix(R,lValue)
            outputs[0].rows = nb
            outputs[0].cols = qlen.value*x.cols
            outputs[0].degree = x.degree
            if qlen.value == 1 and nb == 1 :
                outputs[0].type = "poly"
                outputs[0].value = outputs[0].value[0][0]
            else :
                outputs[0].type = "matrixPoly"

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_prodOfAdd(self) :
        """ SpecificFunction prodOfAdd (inputs: L,M, outputs: N):
                L = [x1,x2] et M = [y1,y2] (L and M has the same length and type.)
                N = [x1y1 , x1y2+x2y1, x2y2]"""

        spec = self.builder.specificFunction("prodOfAdd", self.flag, self.file)

        # L and M are list or listPoly
        inputs = [self.builder.parameter("L","NoType",0,1,2), self.builder.parameter("M","NoType",0,1,2)]

        spec.inputs = inputs

        mult = self.finder.atomic(self.allAtomics, "mult")
        add = self.finder.atomic(self.allAtomics, "add")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecProdOfAdd_" + spec.count.str(),"NoType",0,1,1)] #list or listPoly
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [L,M] = spec.inputs
            rowsL = L.rows
            colsL = L.cols
            rowsM = M.rows
            colsM = M.cols

            # If L or M has n*1 for dimensions, it is transposed
            if colsL == 1 and rowsL != 1 :
                L.value = L.value.transpose()
                L.rows = colsL
                L.cols = rowsL
                rowsL = colsL
                colsL = L.cols
            if colsM == 1 and rowsM != 1 :
                val = []
                inVal = M.value
                for i in range(rowsM) :
                    val = val + [inVal[i][0]]
                M.value = val
                M.rows = colsM
                M.cols = rowsM
                rowsM = colsM
                colsM = M.cols

            valM = M.value
            valL = L.value
            deg1 = L.degree
            deg2 = M.degree

            if colsM != colsL :
                raise Exception("prodOfAdd can not be executed with Parameter of different size.")

            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.parameter(outputs[0], L.type, [], 1, colsL*2-1, deg1+deg2)
            else :
                outputs[0].value = []
                outputs[0].rows = 1
                outputs[0].type = L.type
                outputs[0].cols = colsL*2-1
                outputs[0].degree = deg1+deg2

            for i in range(colsL) :
                outputs[0].value = outputs[0].value + mult.ope([valL[i], valM[i]])
                # outputs[0].value = outputs[0].value + [valL[i] * valM[i]]
                for j in range(i+1,colsL) :
                    # outputs[0].value = outputs[0].value + [valL[i]*valM[j] + valL[j]*valM[i]]
                    [tmp1] = mult.ope([valL[i], valM[j]], ["TmpSpecProdOfAdd_a_" + spec.count.str()])
                    [tmp2] = mult.ope([valL[j], valM[i]], ["TmpSpecProdOfAdd_b_" + spec.count.str()])
                    outputs[0].value = outputs[0].value + add.ope([tmp1, tmp2])

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_powersOf(self) :
        """ SpecificFunction powersOf (inputs: x,w,q, outputs: L):
                Returns a vector containing coefficients in x multiplied by power of w. """
        spec = self.builder.specificFunction("powersOf", self.flag, self.file)

        inputs = [self.builder.parameter("x","poly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs

        pow = self.finder.atomic(self.allAtomics, "pow")
        mult = self.finder.atomic(self.allAtomics, "mult")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecPowersOf_" + spec.count.str(),"matrix",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [x,w,q] = spec.inputs
            [R] = sets
            qlen = floor(log(q.value,w.value), bits=1000)+1

            if not(isinstance(outputs[0], Parameter)) :
                if qlen == 1 :
                    outputs[0] = self.builder.parameter(outputs[0],"poly",[],1,qlen, x.degree)
                else :
                    outputs[0] = self.builder.parameter(outputs[0],"matrixPoly",[],1,qlen, x.degree)
            else :
                outputs[0].value = []
                outputs[0].rows = 1
                outputs[0].cols = qlen
                outputs[0].degree = x.degree
                if qlen == 1 :
                    outputs[0].type = "poly"
                else :
                    outputs[0].type = "matrixPoly"

            outputs[0].cols = qlen

            for i in range(qlen) :
                [tmpa] = pow.ope([w,i], ["TmpSpecPowersOf_a_" + spec.count.str()])
                [tmpb] = mult.ope([x,tmpa], ["TmpSpecPowersOf_b_" + spec.count.str()])
                outputs[0].value = outputs[0].value + [tmpb.value]

            outputs[0].value = matrix(R,outputs[0].value)
            if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(R) :
                outputs[0].degree = R.degree()

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_doubleMultInv(self) :
        """ SpecificFunction doubleMultInv (inputs: t,g,f,p,q, sets : R):
            Returns (t * g * R(f^(-1) mod p)) mod q """
        spec = self.builder.specificFunction("doubleMultInv", self.flag, self.file)

        t = self.builder.parameter("t","int",0,1,1)
        g = self.builder.parameter("g","poly",0,1,1)
        f = self.builder.parameter("f","poly",0,1,1)
        p = self.builder.parameter("p","poly",0,1,1)
        q = self.builder.parameter("q","int",0,1,1)

        inputs = [t,g,f,p,q]
        spec.inputs = inputs

        mult = self.finder.atomic(self.allAtomics, "mult")
        mod = self.finder.atomic(self.allAtomics, "mod")
        inv = self.finder.atomic(self.allAtomics, "inv")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecDoubleMultInv_" + spec.count.str(),"poly",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"poly",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [t,g,f,p,q] = spec.inputs
            [R] = sets

            [tmp] = inv.ope([f,p], [R], ["TmpSpecDoubleMultInv_" + spec.count.str()])
            tmp.value = R(tmp.value)
            [tmp] = mod.ope([tmp,q],[tmp])
            [tmp] = mult.ope([g,tmp],[tmp])
            [tmp] = mod.ope([tmp,p],[tmp])
            tmp.value = R(tmp.value)
            [tmp] = mult.ope([tmp,t],[tmp])
            outputs[0].value = tmp.value

            spec.outputs = outputs
            outputs[0].value = tmp.value
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_randMultMod(self) :
        """ SpecificFunction randMultMod (inputs: t,q, sets: D, R):
                f <-- R(D())
                f = (tf + 1) mod q """
        spec = self.builder.specificFunction("randMultMod", self.flag, self.file)

        t = self.builder.parameter("t","int",0,1,1)
        q = self.builder.parameter("q","int",0,1,1)

        inputs = [t,q]
        spec.inputs = inputs

        rand = self.finder.atomic(self.allAtomics, "rand")
        mod = self.finder.atomic(self.allAtomics, "mod")
        addTimes = self.make_addTimes()

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecRandMultMod_" + spec.count.str(),"poly",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"poly",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [t,q] = spec.inputs
            [D, R, Rq] = sets

            outputs = rand.ope([1,1,D.n], [D, Rq], [outputs[0]])
            outputs[0].value = R(outputs[0].value)
            outputs = mod.ope([outputs[0],q],[outputs[0]])
            outputs = addTimes.ope([1,outputs[0],t], [outputs[0]])
            outputs = mod.ope([outputs[0],q],[outputs[0]])
            outputs[0].value = Rq(outputs[0].value)

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_wordDecompInv(self) :
        """ SpecificFunction wordDecompInv (inputs: x,w,q):
            Inverse function of wordDecomp. """
        spec = self.builder.specificFunction("wordDecompInv", self.flag, self.file)

        inputs = [self.builder.parameter("x","matrixPoly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs

        add = self.finder.atomic(self.allAtomics, "add")
        pow = self.finder.atomic(self.allAtomics, "pow")
        mult = self.finder.atomic(self.allAtomics, "mult")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecWordDecompInv_" + spec.count.str(),"NoType",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1) #poly or matrixPoly
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [x,w,q] = spec.inputs
            xCopy = self.builder.parameter(x.name+"copy", x.type, x.value, x.rows, x.cols, x.degree)
            qlen = self.builder.parameter("TmpSpecWordDecomp_qlen_" + spec.count.str(), "int", floor(log(q.value,w.value), bits=1000) + 1,1,1,0)

            if x.rows != 1 :
                R = xCopy.value[0][0].parent()
                outputs[0].type = "matrixPoly"
                outputs[0].value = []
                outputs[0].rows = xCopy.rows
                outputs[0].cols = xCopy.cols/qlen.value
            else :
                R = xCopy.value.parent()
                xCopy.value = matrix(R, [xCopy.value])
                outputs[0].type = "poly"
                outputs[0].rows = 1
                outputs[0].cols = 1
            outputs[0].degree = xCopy.degree

            tmp = self.builder.parameter("TmpSpecWordDecompInv_aa_" + spec.count.str(), "poly", R(0),1,1,0)
            spec.count = spec.count + 1

            for i in range(xCopy.rows) : #for every row
                ligne = []
                for j in range(xCopy.cols/qlen.value) : #each element of ci column...
                    tmp.value = R(0)
                    for k in range(qlen.value) :
                        [tmp1] = pow.ope([w,k],["TmpSpecWordDecompInv_a_" + spec.count.str()])
                        #...is multiplied by 2^i
                        [tmp2] = mult.ope([xCopy[i][j*qlen.value + k],tmp1],["TmpSpecWordDecompInv_b_" + spec.count.str()])
                        #result is put in tmp
                        [tmp] = add.ope([tmp, tmp2], [tmp])
                    ligne = ligne + [tmp.value]
                if xCopy.rows != 1 :
                    outputs[0].value = outputs[0].value + [ligne]
                else :
                    outputs[0].value = outputs[0].value + ligne[0]

            if xCopy.rows != 1 :
                outputs[0].value = matrix(R, outputs[0].value)

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_flatten(self) :
        """ SpecificFunction flatten (inputs: x,w,q, outputs: L):
            Returns wordDecomp(wordDecompInv(x,w,q) mod q ,w,q) """

        spec = self.builder.specificFunction("flatten", self.flag, self.file)

        inputs = [self.builder.parameter("x","matrixPoly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs

        wordDecomp = self.make_wordDecomp()
        wordDecompInv = self.make_wordDecompInv()
        mod = self.finder.atomic(self.allAtomics, "mod")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecFlatten_" + spec.count.str(),"matrixPoly",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"matrixPoly",0,1,1)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [x,w,q] = spec.inputs

            [tmp] = wordDecompInv.ope([x,w,q], ["TmpSpecFlatten_" + spec.count.str()])
            [tmp] = mod.ope([tmp,q],[tmp])
            outputs = wordDecomp.ope([tmp,w,q], [outputs[0]])

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec

    def make_msbToPolynomial(self) :
        """ SpecificFunction msbToPolynomial (inputs: M,d,l, set: R) (Specific to be used in Decryption function of SHIELD scheme) """
        spec = self.builder.specificFunction("msbToPolynomial", self.flag, self.file)

        #M is of type n * 1 with n an integer.
        #d: degree of polynomials in M
        inputs = [self.builder.parameter("M","matrixPoly",0,1,1), self.builder.parameter("d","int",0,1,1), self.builder.parameter("l","int",0,1,1)]
        spec.inputs = inputs

        add = self.finder.atomic(self.allAtomics, "add")
        pow = self.finder.atomic(self.allAtomics, "pow")
        mult = self.finder.atomic(self.allAtomics, "mult")
        digits = self.finder.atomic(self.allAtomics, "digits")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecMsbToPolynomial_" + spec.count.str(),"poly",0,1,1)]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"poly",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], count = spec.count) :
            time1 = time.time()
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [M,d,l] = spec.inputs
            [R] = sets

            if M.rows == 1 and M.cols > 1 :
                tmp = M.cols
                M.cols = M.rows
                M.rows = tmp
                M.value = M.transpose()

            L = self.builder.parameter("TmpSpecMsbToPolynomial_L_" + spec.count.str(), "list", [], 0,0,0)
            tmp2 = self.builder.parameter("TmpSpecMsbToPolynomial_int_" + spec.count.str(), "int", 0, 1,1,0)
            power = self.builder.parameter("TmpSpecMsbToPolynomial_power_" + spec.count.str(), "int", 0, 1,1,0)
            outputs[0].value = []

            for i in range(d.value+1) :
                L.value = []
                for j in range(M.rows) :
                    [tmp] = digits.ope([M[j][0][i], 2, M.rows], ["TmpSpecMsbToPolynomial_digits_" + spec.count.str()])
                    L.value = L.value + [tmp[0][0]]
                L.value.reverse()
                tmp2.value = 0
                for i in range(M.rows) :
                    power.value = 0
                    [power] = pow.ope([2,i], [power])
                    [power] = mult.ope([L.value[i], power], [power])
                    [tmp2] = add.ope([tmp2, power], [tmp2])
                outputs[0].value = outputs[0].value + [tmp2.value]

            outputs[0].value = R(outputs[0].value)
            outputs[0].type = "poly"
            outputs[0].rows = 1
            outputs[0].cols = 1
            outputs[0].degree = 1

            spec.outputs = outputs
            time2 = time.time()
            spec.printInFile(spec, str(time2-time1))
            return spec.outputs

        spec.ope = ope

        return spec
