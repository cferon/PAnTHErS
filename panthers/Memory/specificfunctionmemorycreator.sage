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


class SpecificFunctionMemoryCreator(object):
    """ SpecificFunctionMemoryCreator allows creating SpecificFunctionMemory objects."""

    def __init__(self) :
        self.builder = Builder()
        self.operator = ObjectOperatorMemory()
        self.finder = Finder()
        self.atomicfunctionmemorycreator = AtomicFunctionMemoryCreator()
        self.allAtomics = self.atomicfunctionmemorycreator.make_all()

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

    def make_addTimes(self) :
        """ SpecificFunctionMemory addTimes: d = a + b * c"""
        spec = self.builder.specificFunctionMemory("addTimes")

        inputs = [self.builder.parameter("a","NoType",0,1,1), self.builder.parameter("b","NoType",0,1,1), self.builder.parameter("c","NoType",0,1,1)]
        spec.inputs = inputs
        spec.memory = Memory()

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

        def ope(inputs, outputs = [], sets = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [a,b,c] = spec.inputs

            # outputs[0] = a + b * c
            [tmp] = mult.ope([b,c], ["TmpSpecAddTimes_" + spec.count.str()], memory)
            [outputs[0]] = add.ope([a,tmp], [outputs[0]], memory)

            if len(sets) != 0 :
                R = sets[0]
                if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(R) :
                    outputs[0].degree = R.degree()

            spec.memory.allMem = [tmp]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_distriLWE(self) :
        """ SpecificFunctionMemory distriLWE (inputs: R, X, n, m, s, k, d, outputs: b, A):
                A <-- random matrix in R_q of dimensions n*m (d: degree of elements in A and e)
                e <-- random vector in X of size n
                b <-- (A*s+k*e) mod q"""
        spec = self.builder.specificFunctionMemory("distriLWE")

        n = self.builder.parameter("n","int",0,1,1)
        m = self.builder.parameter("m","int",0,1,1)
        k = self.builder.parameter("k","int",0,1,1)
        d = self.builder.parameter("d","int",0,1,1)
        s = self.builder.parameter("s","matrix",0,m,1)
        q = self.builder.parameter("q","int",0,1,1)
        inputs = [n,m,k,d,s,q]

        spec.inputs = inputs
        spec.memory = Memory()

        rand = self.finder.atomic(self.allAtomics, "rand")
        mult = self.finder.atomic(self.allAtomics, "mult")
        add = self.finder.atomic(self.allAtomics, "add")
        mod = self.finder.atomic(self.allAtomics, "mod")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                b = self.builder.parameter("OutSpecDistriLWE_b_" + spec.count.str(),"NoType",0,m,1) #matrix or matrixPoly
                A = self.builder.parameter("OutSpecDistriLWE_A_" + spec.count.str(),"NoType",0,m,n) #matrix or matrixPoly
                outputs = [b,A]
                spec.outputs = outputs
                spec.count = spec.count + 1
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,m,1)
                if isinstance(outputs[1], str) :
                    outputs[1] = self.builder.parameter(outputs[1],"NoType",0,m,n)
                return outputs

        def ope(inputs, sets, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [n,m,k,d,s,q] = spec.inputs
            [b,A] = outputs
            if len(sets) == 3 :
                [R, X1, X2] = sets
            elif len(sets) == 2 :
                [R, X1] = sets

            if len(sets) == 3 :
                [A] = rand.ope([n,m,d], [X2, R], [A], memory)
                [A] = mod.ope([A, q], [A], memory)
            elif len(sets) == 2 :
                [A] = rand.ope([n,m,d], [R], [A], memory)
                [A] = mod.ope([A, q], [A], memory)
            [e] = rand.ope([n,1,d], [X1,R], ["TmpSpecDistriLWE_" + spec.count.str()], memory)
            spec.count = spec.count + 1

            #outputs[0] = A*s + k*e
            [outputs[0]] = mult.ope([A,s], [outputs[0]], memory)
            [e] = mult.ope([k,e], [e], memory)
            [outputs[0]] = add.ope([outputs[0],e], [outputs[0]], memory)

            outputs[1] = A

            spec.memory.allMem = [e]
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_doubleDistriLWE(self) :
        """ SpecificFunctionMemory doubleDistriLWE (inputs: Rq, Rp, X, n, m, d, s1, s2, outputs: b1, b2):
                A <-- random matrix in R_p of dimensions m*n (d: degree of elements in A, e1 and e2)
                e1 <-- random vector in X of size m
                e2 <-- random vector in X of size m
                b1 <-- (A*s1 + e1) mod q (dans Rq)
                b2 <-- (A*s2 + e2) mod q (dans Rq)"""
        spec = self.builder.specificFunctionMemory("doubleDistriLWE")

        n = self.builder.parameter("n","int",0,1,1)
        m = self.builder.parameter("m","int",0,1,1)
        d = self.builder.parameter("d","int",0,1,1)
        s1 = self.builder.parameter("s1","matrixOrMatrixPoly",0,m,1)
        s2 = self.builder.parameter("s2","matrixOrMatrixPoly",0,m,1)
        inputs = [n,m,d,s1,s2]

        spec.inputs = inputs
        spec.memory = Memory()

        rand = self.finder.atomic(self.allAtomics, "rand")
        addTimes = self.make_addTimes()

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                b1 = self.builder.parameter("OutSpecDoubleDistriLWE_b1_" + spec.count.str(),"NoType",0,m,1) #matrix or matrixPoly
                b2 = self.builder.parameter("OutSpecDoubleDistriLWE_b2_" + spec.count.str(),"NoType",0,m,1) #matrix or matrixPoly
                outputs = [b1,b2]
                spec.outputs = outputs
                spec.count = spec.count + 1
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,m,1)
                if isinstance(outputs[1], str) :
                    outputs[1] = self.builder.parameter(outputs[1],"NoType",0,m,1)
                return outputs

        def ope(inputs, sets, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [n,m,d,s1,s2] = spec.inputs
            [b1,b2] = outputs
            [Rp,Rq,X] = sets

            [A] = rand.ope([n,m,d], [Rp, Rq], ["TmpSpecDoubleDistriLWE_A_" + spec.count.str()], memory)

            [e1] = rand.ope([n,1,d], [X, Rq], ["TmpSpecDoubleDistriLWE_e1_" + spec.count.str()], memory)
            [e2] = rand.ope([n,1,d], [X, Rq], ["TmpSpecDoubleDistriLWE_e2_" + spec.count.str()], memory)
            spec.count = spec.count + 1

            [b1] = addTimes.ope([e1,A,s1], [b1], [Rq], memory)
            [b2] = addTimes.ope([e2,A,s2], [b2], [Rq], memory)

            spec.memory.allMem = [A, e1, e2]
            spec.outputs = [b1,b2]
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_doubleMod(self) :
        """ SpecificFunctionMemory doubleMod (inputs: a,p,q, outputs: m):
                m <-- (a mod p) mod q
            p and q must be Parameters of type int or poly."""
        spec = self.builder.specificFunctionMemory("doubleMod")

        a = self.builder.parameter("a","NoType",0,1,1)
        p = self.builder.parameter("p","intOrPoly",0,1,1)
        q = self.builder.parameter("q","intOrPoly",0,1,1)
        inputs = [a,p,q]

        spec.inputs = inputs
        spec.memory = Memory()

        mod = self.finder.atomic(self.allAtomics, "mod")

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

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [a,p,q] = spec.inputs

            [outputs[0]] = mod.ope([a,p], [outputs[0]], memory)
            [outputs[0]] = mod.ope([outputs[0],q], [outputs[0]], memory)

            spec.memory.allMem = []
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_prodScalMod(self) :
        """ SpecificFunctionMemory prodScalMod (inputs: a,b,p,q, outputs: m):
                m <-- <a,b> (dot product of a and b)
                m <-- (m mod p) mod q (doubleMod)
            a and b are vectors of same size."""
        spec = self.builder.specificFunctionMemory("prodScalMod")

        a = self.builder.parameter("a","matrix",0,1,1)
        b = self.builder.parameter("b","matrix",0,1,1)
        p = self.builder.parameter("p","intOrPoly",0,1,1)
        q = self.builder.parameter("q","intOrPoly",0,1,1)
        inputs = [a,b,p,q]

        spec.inputs = inputs
        spec.memory = Memory()

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

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [a,b,p,q] = spec.inputs
            [m] = outputs

            [m] = prodScal.ope([a,b],[m], memory)
            spec.outputs = doubleMod.ope([m,p,q],[m], memory)
            spec.memory.allMem = []
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_pubKeyGen(self) :
        """ SpecificFunctionMemory pubKeyGen (inputs: k,b,A, outputs: P):
                P <-- b || k.A
            with k integer and || concatenation """
        spec = self.builder.specificFunctionMemory("pubKeyGen")

        inputs = [self.builder.parameter("k","int",0,1,1), self.builder.parameter("b","NoType",0,8,1), self.builder.parameter("A","NoType",0,2,8)]
        spec.inputs = inputs
        spec.memory = Memory()

        mult = self.finder.atomic(self.allAtomics, "mult")

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

        def ope(inputs, outputs = [], sets = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [k,b,A] = spec.inputs

            #outputs[0] = k*A
            [outputs[0]] = mult.ope([k,A], [outputs[0]], memory)
            # NOT NECESSARY IN MEMORY ANALYSIS
            #outputs[0].value = block_matrix(1,2,[b.value, outputs[0].value])
            outputs[0].cols = b.cols + A.cols

            if len(sets) != 0 :
                R = sets[0]
                if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(R) :
                    outputs[0].degree = R.degree()

            spec.memory.allMem = []
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_changeMod(self) :
        """ SpecificFunctionMemory changeMod (inputs: q,p,t,m):
            Returns round((t/q) * m) mod p """
        spec = self.builder.specificFunctionMemory("changeMod")

        q = self.builder.parameter("q","int",0,1,1)
        p = self.builder.parameter("p","int",0,1,1)
        t = self.builder.parameter("t","int",0,1,1)
        m = self.builder.parameter("m","intOrPoly",0,1,1)
        inputs = [q,p,t,m]

        spec.inputs = inputs
        spec.memory = Memory()

        round = self.finder.atomic(self.allAtomics, "round")
        mod = self.finder.atomic(self.allAtomics, "mod")
        div = self.finder.atomic(self.allAtomics, "div")
        mult = self.finder.atomic(self.allAtomics, "mult")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecChangeMod_" + spec.count.str(),"NoType",0,1,1)] #int or poly
                spec.outputs = outputs
                spec.count = spec.count + 1
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [q,p,t,m] = spec.inputs

            [outputs[0]] = mult.ope([m,t], [outputs[0]], memory)
            [outputs[0]] = div.ope([outputs[0],q], [outputs[0]], memory)
            [outputs[0]] = round.ope([outputs[0]], [outputs[0]], memory)
            [outputs[0]] = mod.ope([outputs[0],p], [outputs[0]], memory)

            spec.memory.allMem = []
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_modCenterInZero(self) :
        """ SpecificFunctionMemory modCenterInZero (inputs: p,q):
            Returns a = p mod q
            with -q/2 < a < q/2 """
        spec = self.builder.specificFunctionMemory("modCenterInZero")

        p = self.builder.parameter("p","NoType",0,1,1) #no float
        q = self.builder.parameter("q","int",0,1,1)
        inputs = [p,q]

        spec.inputs = inputs
        spec.memory = Memory()

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

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [p,q] = spec.inputs

            tmpAdd = self.builder.parameter("TmpSpecmodCenterInZero_add_" + spec.count.str(), "poly", R(0),1,1,0)
            tmpSub = self.builder.parameter("TmpSpecmodCenterInZero_sub_" + spec.count.str(), "poly", R(0),1,1,0)
            memory.add(tmpAdd)
            memory.add(tmpSub)
            memory.raise_memTmp(tmpAdd)
            memory.raise_memTmp(tmpSub)

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS

            if p.type == "matrix" :
                #for i in range(p.rows) :
                #    for j in range(p.cols) :
                #       if p.value[i][j] < -((q.value-1)/2) :
                [tmpAdd] = add.ope([tmpAdd,q], [tmpAdd], memory)
                #           p.value[i][j] = tmp.value
                #        if p.value[i][j] > ((q.value-1)/2) :
                [tmpSub] = sub.ope([tmpSub,q], [tmpSub], memory)
                #            p.value[i][j] = tmp.value

            elif p.type == "matrixPoly" :
                #for i in range(p.rows) :
                #    for j in range(p.cols) :
                #        L = list(p.value[i][j])
                #        R = p.value[i][j].parent()
                #        for k in range(len(L)) :
                #            if L[k] < -((q.value-1)/2) :
                [tmpAdd] = add.ope([tmpAdd,q], [tmpAdd], memory)
                #               L[k] = tmp.value
                #            if L[k] > ((q.value-1)/2) :
                [tmpSub] = sub.ope([tmpSub,q], [tmpSub], memory)
                #                L[k] = tmp.value
                #        p.value[i][j] = R(L)

            elif p.type == "int" :
                # if p.value < -((q.value-1)/2) :
                [p] = add.ope([p,q], [p], memory)
                #if p.value > ((q.value-1)/2) :
                [p] = sub.ope([p,q], [p], memory)

            elif p.type == "poly" :
                #L = list(p.value)
                #R = p.value.parent()
                #for i in range(len(L)) :
                #    if L[i] < -((q.value-1)/2) :
                [tmpAdd] = add.ope([tmpAdd,q], [tmpAdd], memory)
                #        L[i] = tmp.value
                #    if L[i] > ((q.value-1)/2) :
                [tmpSub] = sub.ope([tmpSub,q], [tmpSub], memory)
                #        L[i] = tmp.value
                #p.value = R(L)

            else :
                raise Exception("modCenterInZero: first Parameter has not the type = matrixPoly, poly, int, matrix but {}".format(p.type))

            outputs[0].rows = p.rows
            outputs[0].cols = p.cols
            outputs[0].degree = p.degree

            spec.memory.allMem = [tmpAdd, tmpSub]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_wordDecomp(self) :
        """ SpecificFunctionMemory wordDecomp (inputs: x,w,q, outputs: L):
                Decompose coefficients of x in base w"""
        spec = self.builder.specificFunctionMemory("wordDecomp")

        inputs = [self.builder.parameter("x","poly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs
        spec.memory = Memory()

        digits = self.finder.atomic(self.allAtomics, "digits")
        mod = self.finder.atomic(self.allAtomics, "mod")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecWordDecomp_" + spec.count.str(),"matrixPoly",0,1,1)]
                spec.outputs = outputs
                spec.count = spec.count + 1
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"matrixPoly",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS

            [x,w,q] = spec.inputs
            nb = 1
            if x.type == "matrixPoly" :
                nb = x.rows
                #R = x.value[0][0].parent()
            #else :
                #R = x.value.parent()

            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.parameter(outputs[0])

            qlen = self.builder.parameter("TmpSpecWordDecomp_qlen_" + spec.count.str(), "int", ceil(log(q.value,w.value), bits=1000),1,1,0)
            memory.add(qlen)
            memory.raise_memTmp(qlen)

            #lValue = []

            #for j in range(nb) :
                #lValueTmp = []
                #for k in range(x.cols) :
            if x.type == "matrixPoly" :
                xTmp = self.builder.parameter(outputs[0].name + "_" + nb.str(), "poly", 0,1,1,x.degree)
            else :
                xTmp = x

            [L] = digits.ope([xTmp,w,qlen],["TmpSpecWordDecomp_L_" + spec.count.str()], memory)

                #for i in range(L.rows) :
                #    lValueTmp = lValueTmp + [R(list(L.value[i]))]

                #lValue = lValue + [lValueTmp]

            #outputs[0].value = matrix(R,lValue)
            outputs[0].rows = nb
            outputs[0].cols = qlen.value*x.cols
            outputs[0].degree = x.degree
            if qlen.value == 1 and nb == 1 :
                outputs[0].type = "poly"
            else :
                outputs[0].type = "matrixPoly"

            spec.memory.allMem = [L, qlen]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_prodOfAdd(self) :
        """ SpecificFunctionMemory prodOfAdd (inputs: L,M, outputs: N):
                L = [x1,x2] et M = [y1,y2] (L and M has the same length and type.)
                N = [x1y1 , x1y2+x2y1, x2y2]"""
        spec = self.builder.specificFunctionMemory("prodOfAdd")

        inputs = [self.builder.parameter("L","listOrListPoly",0,1,2), self.builder.parameter("M","listOrListPoly",0,1,2)]
        spec.inputs = inputs
        spec.memory = Memory()

        mult = self.finder.atomic(self.allAtomics, "mult")
        add = self.finder.atomic(self.allAtomics, "add")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecProdOfAdd_" + spec.count.str(),"NoType",0,1,1)] #list or listPoly
                spec.outputs = outputs
                spec.count = spec.count + 1
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"NoType",0,1,1)
                return outputs

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
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
                outputs[0].value = outputs[0].value + mult.ope([valL[i], valM[i]], memory = memory)
                for j in range(i+1,colsL) :
                    [tmp1] = mult.ope([valL[i], valM[j]], ["TmpSpecProdOfAdd_a_" + spec.count.str()], memory)
                    [tmp2] = mult.ope([valL[j], valM[i]], ["TmpSpecProdOfAdd_b_" + spec.count.str()], memory)
                    outputs[0].value = outputs[0].value + add.ope([tmp1, tmp2], memory = memory)
            spec.count = spec.count + 1

            spec.memory.allMem = [tmp1, tmp2]
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_powersOf(self) :
        """ SpecificFunctionMemory powersOf (inputs: x,w,q, outputs: L):
                Returns a vector containing coefficients in x multiplied by power of w. """
        spec = self.builder.specificFunctionMemory("powersOf")

        inputs = [self.builder.parameter("x","poly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs
        spec.memory = Memory()

        mult = self.finder.atomic(self.allAtomics, "mult")
        pow = self.finder.atomic(self.allAtomics, "pow")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                outputs = [self.builder.parameter("OutSpecPowersOf_" + spec.count.str(),"matrixPoly",0,1,1)]
                spec.outputs = outputs
                spec.count = spec.count + 1
                return outputs
            else :
                if isinstance(outputs[0], str) :
                    outputs[0] = self.builder.parameter(outputs[0],"matrixPoly",0,1,1)
                return outputs

        def ope(inputs, sets, outputs = [], memory = spec.memory, count = spec.count) :
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

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS
            #for i in range(qlen) :
                #outputs[0].value = outputs[0].value + [(x*w^i).value]
            [tmp] = pow.ope([w,3], ["TmpSpecPowersOf_a_" + spec.count.str()], memory)
            tmp.value = w.value
            [tmp2] = mult.ope([x,tmp], ["TmpSpecPowersOf_b_" + spec.count.str()], memory)

            if len(sets) != 0 :
                if sage.rings.polynomial.polynomial_quotient_ring.is_PolynomialQuotientRing(R) :
                    outputs[0].degree = R.degree()

            spec.count = spec.count + 1
            spec.memory.allMem = [tmp, tmp2]
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_doubleMultInv(self) :
        """ SpecificFunctionMemory doubleMultInv (inputs: t,g,f,p,q, sets : R):
            Returns (t * g * R(f^(-1) mod p)) mod q """
        spec = self.builder.specificFunctionMemory("doubleMultInv")

        t = self.builder.parameter("t","int",0,1,1)
        g = self.builder.parameter("g","poly",0,1,1)
        f = self.builder.parameter("f","poly",0,1,1)
        p = self.builder.parameter("p","poly",0,1,1)
        q = self.builder.parameter("q","int",0,1,1)

        inputs = [t,g,f,p,q]
        spec.inputs = inputs
        spec.memory = Memory()

        mult = self.finder.atomic(self.allAtomics, "mult")
        inv = self.finder.atomic(self.allAtomics, "inv")
        mod = self.finder.atomic(self.allAtomics, "mod")

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

        def ope(inputs, sets, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [t,g,f,p,q] = spec.inputs
            [R] = sets

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS

            [tmp] = inv.ope([f,p], [R], ["TmpSpecDoubleMultInv_" + spec.count.str()], memory)
            #tmp.value = R(tmp.value)
            [tmp] = mod.ope([tmp,q],[tmp], memory)
            [tmp] = mult.ope([g,tmp],[tmp], memory)
            [tmp] = mod.ope([tmp,p],[tmp], memory)
            #tmp.value = R(tmp.value)
            [tmp] = mult.ope([tmp,t],[tmp], memory)
            #outputs[0].value = tmp.value

            spec.memory.allMem = [tmp]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_randMultMod(self) :
        """ SpecificFunctionMemory randMultMod (inputs: t,q, sets: D, R):
                f <-- R(D())
                f = (tf + 1) mod q """
        spec = self.builder.specificFunctionMemory("randMultMod")

        t = self.builder.parameter("t","int",0,1,1)
        q = self.builder.parameter("q","int",0,1,1)

        inputs = [t,q]
        spec.inputs = inputs
        spec.memory = Memory()

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

        def ope(inputs, sets, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            [t,q] = spec.inputs
            [D, R, Rq] = sets

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS

            outputs = rand.ope([1,1,D.n], [D, Rq], [outputs[0]], memory)
            #outputs[0].value = R(outputs[0].value)
            outputs = mod.ope([outputs[0],q],[outputs[0]], memory)
            outputs = addTimes.ope([1,outputs[0],t], [outputs[0]], memory = memory)
            outputs = mod.ope([outputs[0],q],[outputs[0]], memory)
            #outputs[0].value = Rq(outputs[0].value)

            spec.memory.allMem = []
            spec.outputs = outputs
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_wordDecompInv(self) :
        """ SpecificFunctionMemory wordDecompInv (inputs: x,w,q):
            Inverse function of wordDecomp. """
        spec = self.builder.specificFunctionMemory("wordDecompInv")

        inputs = [self.builder.parameter("x","matrixPoly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs
        spec.memory = Memory()

        pow = self.finder.atomic(self.allAtomics, "pow")
        mult = self.finder.atomic(self.allAtomics, "mult")
        add = self.finder.atomic(self.allAtomics, "add")

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

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [x,w,q] = spec.inputs

            qlen = self.builder.parameter("TmpSpecWordDecomp_qlen_" + spec.count.str(), "int", floor(log(q.value,w.value), bits=1000) + 1,1,1,0)
            memory.add(qlen)
            memory.raise_memTmp(qlen)

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS

            if x.cols != 1 :
                outputs[0].type = "matrixPoly"
                outputs[0].value = []
                outputs[0].rows = x.rows
                outputs[0].cols = x.cols/qlen.value
                #R = x.value[0][0].parent()
            else :
                outputs[0].type = "poly"
                outputs[0].rows = 1
                outputs[0].cols = 1
                #R = x.value.parent()
            outputs[0].degree = x.degree

            tmp = self.builder.parameter("TmpSpecWordDecompInv_aa_" + spec.count.str(), "poly", 0,1,1,0)
            memory.add(tmp)
            memory.raise_memTmp(tmp)
            xBis = self.builder.parameter("TmpSpecWordDecompInv_x_" + spec.count.str(), "poly", 0,1,1,x.degree)
            memory.add(xBis)
            memory.raise_memTmp(xBis)

            #for i in range(x.rows) :
            #    ligne = []
            #    for j in range(x.cols/qlen.value) :
            #        tmp.value = R(0)
            #        for k in range(qlen.value) :
            [tmp1] = pow.ope([w,3],["TmpSpecWordDecompInv_a_" + spec.count.str()], memory)
            [tmp2] = mult.ope([xBis,tmp1],["TmpSpecWordDecompInv_b_" + spec.count.str()], memory)
            [tmp] = add.ope([tmp, tmp2], [tmp], memory)
                    #ligne = ligne + [tmp.value]
                #if xCopy.rows != 1 :
                #    outputs[0].value = outputs[0].value + [ligne]
                #else :
                #    outputs[0].value = outputs[0].value + ligne[0]

            spec.memory.allMem = [tmp, tmp1, tmp2, xBis, qlen]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_flatten(self) :
        """ SpecificFunctionMemory flatten (inputs: x,w,q, outputs: L):
            Returns wordDecomp(wordDecompInv(x,w,q) mod q ,w,q) """
        spec = self.builder.specificFunctionMemory("flatten")

        inputs = [self.builder.parameter("x","matrixPoly",0,1,1), self.builder.parameter("w","int",0,1,1), self.builder.parameter("q","int",0,1,1)]
        spec.inputs = inputs
        spec.memory = Memory()

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

        def ope(inputs, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            [x,w,q] = spec.inputs

            [tmp] = wordDecompInv.ope([x,w,q], ["TmpSpecFlatten_" + spec.count.str()], memory)
            [tmp] = mod.ope([tmp,q],[tmp], memory)
            outputs = wordDecomp.ope([tmp,w,q], [outputs[0]], memory)

            spec.memory.allMem = [tmp]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec

    def make_msbToPolynomial(self) :
        """ SpecificFunctionMemory msbToPolynomial (inputs: M,d,l, set: R) (Specific to be used in Decryption function of SHIELD scheme) """
        spec = self.builder.specificFunctionMemory("msbToPolynomial")

        #M is of type n * 1 with n an integer.
        #d: degree of polynomials in M
        inputs = [self.builder.parameter("M","matrixPoly",0,1,1), self.builder.parameter("d","int",0,1,1), self.builder.parameter("l","int",0,1,1)]
        spec.inputs = inputs
        spec.memory = Memory()

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

        def ope(inputs, sets, outputs = [], memory = spec.memory, count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs

            # ALL COMMENTED LINES ARE NOT NECESSARY IN MEMORY ANALYSIS

            [M,d,l] = spec.inputs
            [R] = sets

            if M.rows == 1 and M.cols > 1 :
                tmp = M.cols
                M.cols = M.rows
                M.rows = tmp
                #M.value = M.transpose()

            L = self.builder.parameter("TmpSpecMsbToPolynomial_L_" + spec.count.str(), "list", [], 1,M.rows,0)
            tmp2 = self.builder.parameter("TmpSpecMsbToPolynomial_int_" + spec.count.str(), "int", 0, 1,1,0)
            power = self.builder.parameter("TmpSpecMsbToPolynomial_power_" + spec.count.str(), "int", 0, 1,1,0)
            m = self.builder.parameter("TmpSpecMsbToPolynomial_m_" + spec.count.str(), "int", 0, 1,1,M.degree)
            memory.add(L)
            memory.add(tmp2)
            memory.add(power)
            memory.add(m)
            memory.raise_memTmp(L)
            memory.raise_memTmp(tmp2)
            memory.raise_memTmp(power)
            memory.raise_memTmp(m)
            #outputs[0].value = []

            #for i in range(d.value+1) :
                #L.value = []
                #for j in range(M.rows) :
            [tmp] = digits.ope([m, 2, M.rows], ["TmpSpecMsbToPolynomial_digits_" + spec.count.str()], memory)
                    #L.value = L.value + [tmp[0][0]]
                #L.value.reverse()
                #tmp2.value = 0
                #for j in range(M.rows) :
            [power] = pow.ope([2,3], [power], memory)
                    #45 <--> L.value[i]
            [power] = mult.ope([45, power], [power], memory)
            [tmp2] = add.ope([tmp2, power], [tmp2], memory)
                #outputs[0].value = outputs[0].value + [tmp2.value]

            #outputs[0].value = R(outputs[0].value)
            outputs[0].type = "poly"
            outputs[0].rows = 1
            outputs[0].cols = 1
            outputs[0].degree = 1

            spec.memory.allMem = [tmp, power, tmp2, L, m]
            spec.outputs = outputs
            spec.count = spec.count + 1
            memory.sortSpec(spec, spec.name + " : ")
            return spec.outputs

        spec.ope = ope

        return spec
