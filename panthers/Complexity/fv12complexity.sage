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


class FV12Complexity(HESchemeComplexity) :
    """ Class of HE scheme: FV12Complexity. """

    def __init__(self, listOfParams, listOfSets, flag = "HEBasic", file = "", complexity = Complexity()) :
        self.builder = Builder()
        self.finder = Finder()

        #Sets and input parameters lists
        [self.R, self.Xerr, self.Xkey] = listOfSets
        [self.n,self.d,self.q,self.w,self.t,self.l,self.delta,self.bKey, self.bErr, self.expFact,self.quotient] = self.defineInParams(listOfParams)

        HESchemeComplexity.__init__(self, [self.n,self.d,self.q,self.w,self.t,self.l,self.delta,self.bKey, self.bErr, self.expFact], listOfSets, complexity)

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
        self.msbToPolynomial = self.finder.specific(self.heMult.allSpecifics, "msbToPolynomial")
        self.modCenterInZero = self.finder.specific(self.heMult.allSpecifics, "modCenterInZero")

        #Creation of the 5 HEBasicFunctionComplexity
        self.keyGen(flag, file)
        self.enc(flag, file)
        self.dec(flag, file)
        self.addHE(flag, file)
        self.multHE(flag, file)

    def defineInParams(self, listOfParams) :
        """ list: list of values
            Changes values (input parameters of FV12) into Parameter objects.
            Order of Parameter list :
                n, d, q, w, t, bKey, bErr, expFact, quotient"""

        n = self.builder.parameter("n", "int", listOfParams[0], 1, 1)
        d = self.builder.parameter("d", "int", listOfParams[1], 1, 1)
        q = self.builder.parameter("q", "int", listOfParams[2], 1, 1)
        w = self.builder.parameter("w", "int", listOfParams[3], 1, 1)
        t = self.builder.parameter("t", "int", listOfParams[4], 1, 1)
        l = self.builder.parameter("l", "int", floor(log(listOfParams[2], listOfParams[3]), bits=1000)+1, 1, 1)
        delta = self.builder.parameter("delta", "int", floor(listOfParams[2]/listOfParams[4], bits=1000), 1, 1)
        bKey = self.builder.parameter("bKey", "int", listOfParams[5], 1, 1)
        bErr = self.builder.parameter("bErr", "int", listOfParams[6], 1, 1)
        expFact = self.builder.parameter("expFact", "int", listOfParams[7], 1, 1)
        quotient = self.builder.parameter("quotient", "poly", (self.R.gen())^(d.value)+1, 1,1, d)

        return [n,d,q,w,t,l,delta,bKey,bErr,expFact,quotient]

    def keyGen(self, flag, file) :
        """ Defines HEKeyGenComplexity object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - Complexity object
            Outputs (keys generated) are put in self.inputs of the HEScheme class.
            """
        self.heKeyGen = self.builder.heKeyGenComplexity()
        self.heKeyGen.complexity = Complexity(flag, file)

        self.heKeyGen.inputs = self.inputs
        sk = self.builder.key("PrivateKey", "poly",0,1,1)
        pk = self.builder.key("PublicKey", "listPoly",[],1,2)
        rlk = self.builder.key("EvaluationKey", "listPoly",[],1,2)
        self.heKeyGen.outputs = [sk,pk,rlk]

        def ope(inputs = self.inputs, sets = self.sets, complexity = self.heKeyGen.complexity) :
            self.heKeyGen.complexity.reset()
            #Private key generation
            [sk] = self.rand.ope([1,1,self.n], [self.Xkey, self.R], ["PrivateKey_"+self.heKeyGen.count.str()], complexity)
            sk = Key(sk)

            #Public key generation
            [pkb, pka] = self.distriLWE.ope([1, 1, 1, self.n, sk, self.q], [self.R, self.Xerr], ["PublicKey_b_"+self.heKeyGen.count.str(), "PublicKey_a_"+self.heKeyGen.count.str()], complexity)
            [pkb] = self.sub.ope([0,pkb], [pkb], complexity)
            [pkb] = self.mod.ope([pkb,self.q], [pkb], complexity)
            [pkb] = self.mod.ope([pkb, self.quotient], [pkb], complexity)
            [pka] = self.mod.ope([pka, self.quotient], [pka], complexity)
            pk = self.builder.key("PublicKey_"+self.heKeyGen.count.str(), "listPoly",[pkb, pka], 1, 2, pkb.degree)

            #Evaluation key generation
            [rlkb, rlka] = self.distriLWE.ope([self.l, 1, 1, self.n, sk, self.q], [self.R, self.Xerr], ["EvaluationKey_b_"+self.heKeyGen.count.str(), "EvaluationKey_a_"+self.heKeyGen.count.str()], complexity)
            [sk2] = self.mult.ope([sk,sk], ["TmpKeyGen_sk2_"+self.heKeyGen.count.str()], complexity)
            [sk3] = self.powersOf.ope([sk2, self.w, self.q], [sk2.value.parent()], ["TmpKeyGen_sk3_"+self.heKeyGen.count.str()], complexity)
            [rlkb] = self.sub.ope([sk3, rlkb], [rlkb], complexity)
            [rlkb] = self.mod.ope([rlkb, self.q], [rlkb], complexity)
            [rlkb] = self.mod.ope([rlkb, self.quotient], [rlkb], complexity)
            [rlka] = self.mod.ope([rlka, self.quotient], [rlka], complexity)
            rlk = self.builder.key("EvaluationKey_"+self.heKeyGen.count.str(), "listPoly", [rlkb, rlka], 1, 2, max(rlkb.degree, rlka.degree))

            self.inputs = self.inputs + [sk,pk,rlk]
            self.heKeyGen.count = self.heKeyGen.count + 1
            complexity.printInFile(self.heKeyGen, "KeyGen ")

        self.heKeyGen.ope = ope

    def enc(self, flag, file) :
        """ Defines HEEncComplexity object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Complexity object
            """
        self.heEnc = self.builder.heEncComplexity()

        self.heEnc.inputs = [self.builder.message("InEnc_" + self.heEnc.count.str(), "plain", "poly",0,1,1,0)]
        self.heEnc.outputs = [self.builder.message("OutEnc_" + self.heEnc.count.str(), "cipher", "listPoly",[],1,2, 0)]

        self.heEnc.complexity = Complexity(flag, file)

        def ope(inputs, outputs = self.heEnc.outputs, complexity = self.heEnc.complexity) :
            self.heEnc.complexity.reset()

            pk = self.get_input("PublicKey_"+(self.heKeyGen.count-1).str())
            m = inputs[0]
            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.message(outputs[0], "cipher", "listPoly", [],1,2,0)

            [c1,c2] = self.doubleDistriLWE.ope( [1, 1, self.n, pk[0], pk[1]] , [self.Xkey, self.R, self.Xerr], complexity = complexity)
            [tmp] = self.mult.ope([m, self.delta], ["TmpEnc_" + self.heEnc.count.str()], complexity)
            [c1] = self.add.ope([c1, tmp], [c1], complexity)
            [c1] = self.mod.ope([c1, self.q], [c1], complexity)
            [c2] = self.mod.ope([c2, self.q], [c2], complexity)

            [c1] = self.mod.ope([c1, self.quotient], [c1], complexity)
            [c2] = self.mod.ope([c2, self.quotient], [c2], complexity)

            outputs[0] = HEMessage(outputs[0].name, [c1, c2], 1, 2, outputs[0].type, "cipher", 0, max(c1.degree, c2.degree))

            self.heEnc.outputs = outputs
            self.heEnc.count = self.heEnc.count + 1
            complexity.printInFile(self.heEnc, "Enc ")
            return self.heEnc.outputs

        self.heEnc.ope = ope

    def dec(self, flag, file) :
        """ Defines HEDecComplexity object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Complexity object
            """
        self.heDec = self.builder.heDecComplexity()

        self.heDec.inputs = [self.builder.message("InDec_" + self.heDec.count.str(), "cipher", "listPoly",[],1,2,0)]
        self.heDec.outputs = [self.builder.message("OutDec_" + self.heDec.count.str(), "plain", "poly",0,1,1,0)]

        self.heDec.complexity = Complexity(flag, file)

        def ope(inputs, outputs = self.heDec.outputs, complexity = self.heDec.complexity) :
            self.heDec.complexity.reset()

            sk = self.get_input("PrivateKey_" + (self.heKeyGen.count-1).str())
            c = inputs[0]

            if not(isinstance(outputs[0], Parameter)) :
                outputs[0] = self.builder.message(outputs[0], "plain", "poly", 0,1,1,0)

            [outputs[0]] = self.mult.ope([c[1], sk], [outputs[0]], complexity)
            [outputs[0]] = self.add.ope([c[0], outputs[0]], [outputs[0]], complexity)
            [outputs[0]] = self.mod.ope([outputs[0], self.q], [outputs[0]], complexity)
            self.heDec.outputs = self.changeMod.ope([self.q, self.t, self.t, outputs[0]] , [outputs[0]], complexity)
            [outputs[0]] = self.mod.ope([outputs[0], self.quotient], [outputs[0]], complexity)

            self.heDec.outputs[0] = HEMessage(self.heDec.outputs[0], group="plain", depth = 0, degree = self.heDec.outputs[0].degree)
            self.heDec.count = self.heDec.count + 1
            complexity.printInFile(self.heDec, "Dec ")
            return self.heDec.outputs

        self.heDec.ope = ope

    def addHE(self, flag, file) :
        """ Defines HEAddComplexity object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Complexity object
            """
        self.heAdd = self.builder.heAddComplexity()
        self.heAdd.complexity = Complexity(flag, file)

        self.heAdd.inputs = [self.builder.message("InHEBasicAdd_c1_" + self.heAdd.count.str(), "cipher", "listPoly",[],1,2,0), \
                    self.builder.message("InHEBasicAdd_c2_" + self.heAdd.count.str(), "cipher", "listPoly",[],1,2,0)]
        self.heAdd.outputs = [self.builder.message("OutHEBasicAdd_" + self.heAdd.count.str(), "cipher", "listPoly",[],1,2,0)]

        def ope(inputs, outputs = self.heAdd.outputs, complexity = self.heAdd.complexity) :
            self.heAdd.complexity.reset()

            [c1, c2] = inputs

            if not(isinstance(outputs[0], Parameter)) :
                depth = max(c1.depth, c2.depth)
                outputs[0] = self.builder.message(outputs[0], "cipher", "listPoly",[],1,2, depth)

            [c] = self.add.ope([c1[0], c2[0]], ["TmpHEBasicAdd_c_" + self.heAdd.count.str()], complexity)
            [c] = self.mod.ope([c, self.q], [c], complexity)
            [d] = self.add.ope([c1[1], c2[1]], ["TmpHEBasicAdd_d_" + self.heAdd.count.str()], complexity)
            [d] = self.mod.ope([d, self.q], [d], complexity)

            outputs[0].value = [c, d]
            outputs[0].degree = max(c.degree, d.degree)
            self.heAdd.outputs = outputs

            self.heAdd.count = self.heAdd.count + 1
            complexity.printInFile(self.heAdd, "AddHE ")
            return self.heAdd.outputs

        self.heAdd.ope = ope

    def multHE(self, flag, file) :
        """ Defines HEMultComplexity object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            - Complexity object
            """
        self.heMult = self.builder.heMultComplexity()

        self.heMult.inputs = [self.builder.message("InHEBasicMult_" + self.heMult.count.str(), "cipher", "listPoly",[],1,2,0), self.builder.message("InHEBasicMult_" + self.heMult.count.str(), "cipher", "listPoly",[],1,2,0)]
        self.heMult.outputs = [self.builder.message("OutHEBasicMult_" + self.heMult.count.str(), "cipher", "listPoly",[],1,2,1)]

        self.heMult.complexity = Complexity(flag, file)

        def ope(inputs, outputs = self.heMult.outputs, complexity = self.heMult.complexity) :
            self.heMult.complexity.reset()

            rlk = self.get_input("EvaluationKey_"+(self.heKeyGen.count-1).str())
            c1 = inputs[0]
            c2 = inputs[1]
            if not(isinstance(outputs[0], Parameter)) :
                depth = max(c1.depth, c2.depth)
                outputs[0] = self.builder.message(outputs[0], "cipher", "listPoly",[],1,2, depth)

            [tmp] = self.prodOfAdd.ope([c1,c2],["TmpHEBasicMult_a_" + self.heMult.count.str()], complexity)

            [ct0] = self.changeMod.ope([self.q, self.q, self.t,tmp[0]] , ["TmpHEBasicMult_ct0_" + self.heMult.count.str()], complexity)
            [ct1] = self.changeMod.ope([self.q, self.q, self.t,tmp[1]] , ["TmpHEBasicMult_ct1_" + self.heMult.count.str()], complexity)
            [ct2] = self.changeMod.ope([self.q, self.q, self.t,tmp[2]] , ["TmpHEBasicMult_ct2_" + self.heMult.count.str()], complexity)

            [ct2] = self.mod.ope([ct2,self.quotient], [ct2], complexity)
            [c3] = self.wordDecomp.ope([ct2,self.w,self.q], ["TmpHEBasicMult_c3_" + self.heMult.count.str()], complexity)

            [c2b] = self.prodScal.ope([c3,rlk[0]], ["TmpHEBasicMult_c2b_" + self.heMult.count.str()], complexity)
            [c2a] = self.prodScal.ope([c3,rlk[1]], ["TmpHEBasicMult_c2a_" + self.heMult.count.str()], complexity)

            [c2b] = self.add.ope([ct0, c2b], [c2b], complexity)
            [c2b] = self.mod.ope([c2b, self.q], [c2b], complexity)
            [c2b] = self.mod.ope([c2b,self.quotient], [c2b], complexity)

            [c2a] = self.add.ope([ct1, c2a], [c2a], complexity)
            [c2a] = self.mod.ope([c2a, self.q], [c2a], complexity)
            [c2a] = self.mod.ope([c2a,self.quotient], [c2a], complexity)

            outputs[0].value = [c2b, c2a]
            outputs[0].depth = outputs[0].depth + 1
            outputs[0].degree = max(c2b.degree, c2a.degree)

            self.heMult.count = self.heMult.count + 1
            complexity.printInFile(self.heMult, "MultHE ")
            self.heMult.outputs = outputs
            return self.heMult.outputs

        self.heMult.ope = ope

    def depth(self) :
        diff = self.delta.value
        q = self.q.value
        l = self.l.value
        t = self.t.value
        w = self.w.value
        bKey = self.bKey.value
        bErr = self.bErr.value
        expFact = self.expFact.value

        freshCipherNoise = bErr * (1 + 2 * expFact * bKey)

        noise = expFact * t * (4 + expFact * bKey) * freshCipherNoise \
            + expFact * expFact * bKey * (bKey + t * t) + expFact * l * w * bErr

        limit = (diff - q%t)/2;
        res = 1

        while noise < limit :
            noise = expFact * t * (4 + expFact * bKey) * noise \
                + expFact * expFact * bKey * (bKey + t * t) + expFact * l * w * bErr
            res = res + 1
        res = res - 1

        return res

    def __repr__(self):
        return "FV12Complexity"
