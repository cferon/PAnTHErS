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


class FNTRUMemory(HESchemeMemory) :
    """ Class of HE scheme: FNTRUMemory. """

    def __init__(self, listOfParams, listOfSets, flag = "HEBasic", file = "") :
        self.builder = Builder()
        self.finder = Finder()
        self.memory = Memory(flag, file)

        #Sets and input parameters lists
        [self.R, self.Xerr, self.Xkey] = listOfSets
        [self.q,self.d,self.w,self.bErr,self.bKey,self.l,self.quotient] = self.defineInParams(listOfParams)

        HESchemeMemory.__init__(self, [self.q,self.d,self.w,self.bErr,self.bKey,self.l,self.quotient], listOfSets, self.memory)
        self.memory.module = self.q

        #Definition of Atomics and Specifics available in PAnTHErS library
        self.add = self.finder.atomic(self.heKeyGen.allAtomics, "add")
        self.mult = self.finder.atomic(self.heKeyGen.allAtomics, "mult")
        self.sub = self.finder.atomic(self.heKeyGen.allAtomics, "sub")
        self.rand = self.finder.atomic(self.heKeyGen.allAtomics, "rand")
        self.mod = self.finder.atomic(self.heMult.allAtomics, "mod")
        self.pow = self.finder.atomic(self.heKeyGen.allAtomics, "pow")
        self.digits = self.finder.atomic(self.heKeyGen.allAtomics, "digits")
        self.prodScal = self.finder.atomic(self.heMult.allAtomics, "prodScal")
        self.div = self.finder.atomic(self.heMult.allAtomics, "div")
        self.round = self.finder.atomic(self.heMult.allAtomics, "round")
        self.inv = self.finder.atomic(self.heMult.allAtomics, "inv")

        self.addTimes = self.finder.specific(self.heKeyGen.allSpecifics, "addTimes")
        self.distriLWE = self.finder.specific(self.heKeyGen.allSpecifics, "distriLWE")
        self.powersOf = self.finder.specific(self.heKeyGen.allSpecifics, "powersOf")
        self.doubleDistriLWE = self.finder.specific(self.heEnc.allSpecifics, "doubleDistriLWE")
        self.changeMod = self.finder.specific(self.heDec.allSpecifics, "changeMod")
        self.prodOfAdd = self.finder.specific(self.heMult.allSpecifics, "prodOfAdd")
        self.wordDecomp = self.finder.specific(self.heMult.allSpecifics, "wordDecomp")
        self.doubleMod = self.finder.specific(self.heMult.allSpecifics, "doubleMod")
        self.prodScalMod = self.finder.specific(self.heMult.allSpecifics, "prodScalMod")
        self.pubKeyGen = self.finder.specific(self.heMult.allSpecifics, "pubKeyGen")
        self.doubleMultInv = self.finder.specific(self.heMult.allSpecifics, "doubleMultInv")
        self.randMultMod = self.finder.specific(self.heMult.allSpecifics, "randMultMod")
        self.wordDecompInv = self.finder.specific(self.heMult.allSpecifics, "wordDecompInv")
        self.flatten = self.finder.specific(self.heMult.allSpecifics, "flatten")
        self.modCenterInZero = self.finder.specific(self.heMult.allSpecifics, "modCenterInZero")

        #Creation of the 5 HEBasicFunctionMemory
        self.keyGen(flag, file)
        self.enc(flag, file)
        self.dec(flag, file)
        self.addHE(flag, file)
        self.multHE(flag, file)

    def defineInParams(self, listOfParams) :
        """ list: list of values
            Changes values (input parameters of FNTRU) into Parameter objects.
            Order of Parameter list :
                q ,d, w, bErr, bKey, l, quotient """

        q = self.builder.parameter("q", "int", listOfParams[0], 1, 1)
        d = self.builder.parameter("d", "int", listOfParams[1], 1, 1)
        w = self.builder.parameter("w", "int", listOfParams[2], 1, 1)
        bErr = self.builder.parameter("bErr", "int", listOfParams[3], 1, 1)
        bKey = self.builder.parameter("bKey", "int", listOfParams[4], 1, 1)
        l = self.builder.parameter("l", "int", floor(log(listOfParams[0], listOfParams[2]), bits=1000) + 1, 1, 1)
        quotient = self.builder.parameter("quotient", "poly", (self.R.gen())^(d.value)+1, 1, 1, d)

        return [q,d,w,bErr,bKey,l,quotient]

    def keyGen(self, flag, file) :
        """ Defines HEKeyGenMemory object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - Memory object
            Outputs (keys generated) are put in self.inputs of the HEScheme class.
            """
        self.heKeyGen = self.builder.heKeyGenMemory()
        self.heKeyGen.memory = Memory(flag, file)

        self.heKeyGen.inputs = self.inputs
        sk = self.builder.key("PrivateKey", "poly",0,1,1)
        pk = self.builder.key("PublicKey", "listPoly",[],1,2)
        self.heKeyGen.outputs = [sk,pk]

        def ope(inputs = self.inputs, sets = self.sets) :
            memory = self.memory
            #Private key generation
            z = self.R.gen()
            Rq.<z> = PolynomialRing(ZZ.quo(self.q.value))

            [sk] = self.randMultMod.ope([2,self.q], [self.Xkey, self.R, Rq], ["PrivateKey_"+self.heKeyGen.count.str()], memory)
            sk = Key(sk)

            #Public key generation
            [pk] = self.rand.ope([1,1,self.d], [self.Xkey, Rq], ["PublicKey_"+self.heKeyGen.count.str()], memory)
            # NOT NECESSARY IN MEMORY ANALYSIS
            #pk.value = self.R(pk.value)
            [pk] = self.doubleMultInv.ope([2, pk, sk, self.quotient, self.q], [self.R], [pk], memory)
            pk = Key(pk)

            # NOT NECESSARY IN MEMORY ANALYSIS
            # sk.value = self.R(sk.value)
            # pk.value = self.R(pk.value)

            self.inputs = self.inputs + [sk,pk]
            self.heKeyGen.count = self.heKeyGen.count + 1
            memory.sortHEBasic(self.heKeyGen, "KeyGen : ", self.inputs)
            self.heKeyGen.memory = memory
            self.memory.update(memory)

        self.heKeyGen.ope = ope

    def enc(self, flag, file) :
        """ Defines HEEncMemory object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Memory object
            """
        self.heEnc = self.builder.heEncMemory()
        self.heEnc.memory = Memory(flag, file)

        self.heEnc.inputs = [self.builder.message("InEnc_" + self.heEnc.count.str(), "plain", "poly",0,1,1,0)]
        self.heEnc.outputs = [self.builder.message("OutEnc_" + self.heEnc.count.str(), "cipher", "matrixPoly",0,self.l,self.l, 0)]

        def ope(inputs, outputs = self.heEnc.outputs) :
            memory = self.memory

            pk = self.get_input("PublicKey_"+(self.heKeyGen.count-1).str())
            m = inputs[0]
            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.message(outputs[0], "cipher", "matrixPoly", 0,self.l.value,1,0)

            [outputs[0], tmp2] = self.distriLWE.ope([self.l,1,2,self.d,pk, self.q], [self.R, self.Xerr, self.Xerr], [outputs[0], "TmpHEBasicEnc_A_" + self.heEnc.count.str()], memory)

            [outputs[0]] = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)
            [outputs[0]] = self.mod.ope([outputs[0], self.quotient], [outputs[0]], memory)
            [outputs[0]] = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)

            [outputs[0]] = self.wordDecomp.ope([outputs[0], self.w, self.q], [outputs[0]], memory)

            if self.l.value == 1 :
                matrixId = self.builder.parameter("TmpHEBasicEnc_identityMatrixM_" + self.heEnc.count.str(), "poly", self.R(1), self.l,self.l,m.degree)
            else :
                matrixId = self.builder.parameter("TmpHEBasicEnc_identityMatrixM_" + self.heEnc.count.str(), "matrixPoly", identity_matrix(self.l.value), self.l,self.l,m.degree)
            [outputs[0]] = self.addTimes.ope([outputs[0], matrixId, m], [outputs[0]], memory = memory)

            [outputs[0]] = self.flatten.ope([outputs[0], self.w, self.q], [outputs[0]], memory)
            [outputs[0]] = self.wordDecompInv.ope([outputs[0], self.w, self.q], [outputs[0]], memory)

            self.heEnc.outputs = [self.builder.message(outputs[0], "cipher", outputs[0].type, outputs[0].value,outputs[0].rows,outputs[0].cols, 0,outputs[0].degree)]
            self.heEnc.count = self.heEnc.count + 1
            memory.sortHEBasic(self.heEnc, "Enc : ", self.heEnc.outputs)
            self.heEnc.memory = memory
            self.memory.update(memory)

            return self.heEnc.outputs

        self.heEnc.ope = ope

    def dec(self, flag, file) :
        """ Defines HEDecMemory object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Memory object
            """
        self.heDec = self.builder.heDecMemory()
        self.heDec.memory = Memory(flag, file)

        self.heDec.inputs = [self.builder.message("InDec_" + self.heDec.count.str(), "cipher", "matrixPoly",0,self.l,self.l,0)]
        self.heDec.outputs = [self.builder.message("OutDec_" + self.heDec.count.str(), "plain", "poly",0,1,1,0)]

        def ope(inputs, outputs = self.heDec.outputs) :
            memory = self.memory
            sk = self.get_input("PrivateKey_" + (self.heKeyGen.count-1).str())
            c = inputs[0]

            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.message(outputs[0], "plain", "poly", 0,1,1,0)

            tmp = self.builder.parameter("TmpHEBasicDec_"+ self.heDec.count.str(), c.type, 0, 1, c.cols, c.degree)

            [tmp1] = self.mult.ope([tmp, sk], ["TmpHEBasicDec_1_"+ self.heDec.count.str()], memory)
            # NOT NECESSARY IN MEMORY ANALYSIS
            # outputs[0].value = tmp1.value[0][0]

            [outputs[0]] = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)
            [outputs[0]] = self.mod.ope([outputs[0], self.quotient], [outputs[0]], memory)
            [outputs[0]] = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)

            [outputs[0]] = self.modCenterInZero.ope([outputs[0], self.q], [outputs[0]], memory)
            [outputs[0]] = self.mod.ope([outputs[0], 2], [outputs[0]], memory)

            self.heDec.outputs = [self.builder.message(outputs[0], "plain", outputs[0].type, outputs[0].value,outputs[0].rows,outputs[0].cols, 0,outputs[0].degree)]
            self.heDec.count = self.heDec.count + 1
            memory.sortHEBasic(self.heDec, "Dec : ", self.heDec.outputs)
            self.heDec.memory = memory
            self.memory.update(memory)

            return self.heDec.outputs

        self.heDec.ope = ope

    def addHE(self, flag, file) :
        """ Defines HEAddMemory object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Memory object
            """
        self.heAdd = self.builder.heAddMemory()
        self.heAdd.memory = Memory(flag, file)

        self.heAdd.inputs = [self.builder.message("InHEBasicAdd_c1_" + self.heAdd.count.str(), "cipher", "matrixPoly",0,self.l,self.l,0), \
                    self.builder.message("InHEBasicAdd_c2_" + self.heAdd.count.str(), "cipher", "matrixPoly",0,self.l,self.l,0)]
        self.heAdd.outputs = [self.builder.message("OutHEBasicAdd_" + self.heAdd.count.str(), "cipher", "matrixPoly",0,self.l,self.l,0)]

        def ope(inputs, outputs = self.heAdd.outputs) :
            memory = self.memory
            [c1, c2] = inputs

            if not(isinstance(outputs[0], Parameter)) :
                depth = max(c1.depth, c2.depth)
                outputs[0] = self.builder.message(outputs[0], "cipher", "matrixPoly",0,1,1, depth)

            outputs = self.add.ope([c1,c2],[outputs[0]], memory)
            [tmpMult] = self.heMult.ope([c1,c2],["TmpHEBasicAdd_"+ self.heAdd.count.str()], memory)
            outputs = self.addTimes.ope([outputs[0], -2, tmpMult], [outputs[0]], memory = memory)

            outputs = self.mod.ope([outputs[0], self.quotient], [outputs[0]], memory)
            outputs = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)

            self.heAdd.outputs = [self.builder.message(outputs[0], "cipher", outputs[0].type, outputs[0].value,outputs[0].rows,outputs[0].cols, max(c1.depth, c2.depth), outputs[0].degree)]
            self.heAdd.count = self.heAdd.count + 1
            memory.sortHEBasic(self.heAdd, "AddHE : ", self.heAdd.outputs)
            self.heAdd.memory = memory
            self.memory.update(memory)

            return self.heAdd.outputs

        self.heAdd.ope = ope

    def multHE(self, flag, file) :
        """ Defines HEMult object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Memory object
            """
        self.heMult = self.builder.heMultMemory()
        self.heMult.memory = Memory(flag, file)

        self.heMult.inputs = [self.builder.message("InHEBasicMult_" + self.heMult.count.str(), "cipher", "matrixPoly",0,self.l,self.l,0), self.builder.message("InHEBasicMult_" + self.heMult.count.str(), "cipher", "matrixPoly",0,self.l,self.l,0)]
        self.heMult.outputs = [self.builder.message("OutHEBasicMult_" + self.heMult.count.str(), "cipher", "matrixPoly",0,self.l,self.l,1)]

        def ope(inputs, outputs = self.heMult.outputs) :
            memory = self.memory
            [c1, c2] = inputs

            if not(isinstance(outputs[0], Parameter)) :
                depth = max(c1.depth, c2.depth)
                outputs[0] = self.builder.message(outputs[0], "cipher", "matrixPoly",0,1,1, depth)

            outputs = self.wordDecomp.ope([c1, self.w, self.q],[outputs[0]], memory)
            outputs = self.mult.ope([outputs[0],c2],[outputs[0]], memory)
            outputs = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)
            outputs = self.mod.ope([outputs[0], self.quotient], [outputs[0]], memory)
            outputs = self.mod.ope([outputs[0], self.q], [outputs[0]], memory)

            self.heMult.outputs = [self.builder.message(outputs[0], "cipher", outputs[0].type, outputs[0].value,outputs[0].rows,outputs[0].cols, max(c1.depth, c2.depth), outputs[0].degree)]

            self.heMult.outputs[0].depth = self.heMult.outputs[0].depth + 1
            self.heMult.count = self.heMult.count + 1
            memory.sortHEBasic(self.heMult, "MultHE : ", self.heMult.outputs)
            self.heMult.memory = memory
            self.memory.update(memory)

            return self.heMult.outputs

        self.heMult.ope = ope

    def depthAverage(self) :
        q = self.q.value
        w = log(self.w.value,2)
        bKey = self.bKey.value
        bErr = self.bErr.value
        l = self.l.value
        d = float(sqrt(self.d.value))

        res = 1

        noise = 2 * d * bErr * (3 * bKey + 1)
        noise = noise + 2 * d * d * bKey

        limit = q/2

        while float(noise) < float(limit) :
            tmp = float(sqrt(res))
            noise = noise - 2 * d * d * bKey
            noise = ((2^w - 1) * tmp * d + 2 * d) * noise
            noise = noise + 2 * d * d * bKey
            res = res + 1

        res = res - 1

        return res

    def depth(self) :
        return self.depthAverage()

    def depthTheory(self) :
        q = self.q.value
        w = log(self.w.value,2)
        bKey = self.bKey.value
        bErr = self.bErr.value
        l = self.l.value
        d = self.d.value

        res = 1

        noise = 2 * d * bErr * (3 * bKey + 1)
        noise = noise + 2 * d * d * bKey

        limit = q/2

        while float(noise) < float(limit) :
            noise = noise - 2 * d * d * bKey
            noise = ((2^w - 1) * res * d + 2 * d) * noise
            noise = noise + 2 * d * d * bKey
            res = res + 1

        res = res - 1

        return res

    def __repr__(self):
        return "FNTRUMemory"
