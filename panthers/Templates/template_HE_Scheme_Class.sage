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


class SchemeName(HEScheme) :
    """ Describe your HE scheme here """

    def __init__(self, listOfParams, listOfSets) :
        self.builder = Builder()
        self.finder = Finder()

        #List your input parameters here
        ["""example: self.p1, self.p2,..."""] = self.defineInParams(listOfParams, listOfSets)
        #List your input sets here
        ["""example: self.R, self.Rq,..."""] = listOfSets

        #Put back your input parameters list here
        HEScheme.__init__(self, ["""example: self.p1, self.p2,..."""], listOfSets)

        #Definition of Atomics and Specifics available in PAnTHErS library
        self.add = self.finder.atomic(self.heMult.allAtomics, "add")
        self.mult = self.finder.atomic(self.heMult.allAtomics, "mult")
        self.sub = self.finder.atomic(self.heMult.allAtomics, "sub")
        self.rand = self.finder.atomic(self.heMult.allAtomics, "rand")
        self.mod = self.finder.atomic(self.heMult.allAtomics, "mod")
        self.pow = self.finder.atomic(self.heMult.allAtomics, "pow")
        self.digits = self.finder.atomic(self.heMult.allAtomics, "digits")
        self.prodScal = self.finder.atomic(self.heMult.allAtomics, "prodScal")
        self.div = self.finder.atomic(self.heMult.allAtomics, "div")
        self.round = self.finder.atomic(self.heMult.allAtomics, "round")
        self.inv = self.finder.atomic(self.heMult.allAtomics, "inv")

        self.addTimes = self.finder.specific(self.heMult.allSpecifics, "addTimes")
        self.distriLWE = self.finder.specific(self.heMult.allSpecifics, "distriLWE")
        self.powersOf = self.finder.specific(self.heMult.allSpecifics, "powersOf")
        self.doubleDistriLWE = self.finder.specific(self.heMult.allSpecifics, "doubleDistriLWE")
        self.changeMod = self.finder.specific(self.heMult.allSpecifics, "changeMod")
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

        #Definition des 5 HEBasicFunction
        self.keyGen()
        self.enc()
        self.dec()
        self.addHE()
        self.multHE()

    def defineInParams(self, listOfParams) :
        """ Build Parameter objects with input parameters values given in listOfParams.
            See Parameter class for a list of all possible values. """

        #Example 1: n1 = self.builder.parameter("n1", "int", listOfParams[0], 1, 1, 0)
        #Example 2: n2 = self.builder.parameter("n2", "poly", listOfParams[1], 1, 1, 25)

        return ["""list of newly Parameter objects created. Example: n1, n2"""]

    def keyGen(self) :
        """ Defines HEKeyGen object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            Outputs (keys generated) are put in self.inputs of the HEScheme class.
            """
        self.heKeyGen = self.builder.heKeyGen()
        self.heKeyGen.inputs = self.inputs

        #Complete function self.builder.key with key information (type, initial value, row, column, degree).
        #Warning: do not change names of the keys.
        sk = self.builder.key("PrivateKey", """type, default value, row, column, degree""")
        pk = self.builder.key("PublicKey", """type, default value, row, column, degree""")
        rlk = self.builder.key("EvaluationKey", """type, default value, row, column, degree""")

        """ Example:
        sk = self.builder.key("PrivateKey", "poly",0,1,1)
        pk = self.builder.key("PublicKey", "listPoly",[],1,2)
        rlk = self.builder.key("EvaluationKey", "listPoly",[],1,2)
        """

        self.heKeyGen.outputs = [sk,pk,rlk]

        def ope(inputs = self.inputs, sets = self.sets, count = self.heKeyGen.count) :
            #If a temporary variable is required, you can use the following name generator to avoid name collisions:
            #     "TmpHEBasicKeyGen_" + self.heKeyGen.count.str()

            #Private key generation

            #Public key generation

            #Evaluation key generation

            #The 3 keys (sk, pk and rlk) are added to the general inputs of the class.
            self.inputs = self.inputs + [sk,pk,rlk]
            self.heKeyGen.count = self.heKeyGen.count + 1

        self.heKeyGen.ope = ope

    def enc(self) :
        """ Defines HEEnc object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            """
        self.heEnc = self.builder.heEnc()

        #Complete input and output HEEnc list with key information (type, initial value, row, column, degree).
        self.heEnc.inputs = [self.builder.message("InEnc_" + self.heEnc.count.str(), "plain", """type, default value, row, column, degree""")]
        self.heEnc.outputs = [self.builder.message("OutEnc_" + self.heEnc.count.str(), "cipher", """type, default value, row, column, degree""")]

        def ope(inputs, outputs = self.heEnc.outputs, count = self.heEnc.count) :

            pk = self.get_input("PublicKey_"+(self.heKeyGen.count-1).str())
            #Split the inputs list in separated parameters
            m = inputs[0]
            if not(isinstance(outputs[0], Parameter)) :
                #Change output HEEnc information (type, initial value, row, column, degree).
                outputs[0] = self.builder.message(outputs[0], "cipher", """type, default value, row, column, degree""")

            #If a temporary variable is required, you can use the following name generator to avoid name collisions:
            #     "TmpHEBasicEnc_" + self.heEnc.count.str()

            #Describe encryption fonction here

            self.heEnc.outputs = outputs
            self.heEnc.count = self.heEnc.count + 1

        self.heEnc.ope = ope

    def dec(self) :
        """ Defines HEDec object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            """
        self.heDec = self.builder.heDec()

        #Complete input and output HEDec list with key information (type, initial value, row, column, degree).
        self.heDec.inputs = [self.builder.message("InDec_" + self.heDec.count.str(), "cipher", """type, default value, row, column, degree""")]
        self.heDec.outputs = [self.builder.message("OutDec_" + self.heDec.count.str(), "plain", """type, default value, row, column, degree""")]

        def ope(inputs, outputs = self.heDec.outputs) :
            sk = self.get_input("PrivateKey_" + (self.heKeyGen.count-1).str())
            #Split the inputs list in separated parameters
            c = inputs[0]

            if not(isinstance(outputs[0], Parameter)) :
                #Change output HEEnc information (type, initial value, row, column, degree).
                outputs[0] = self.builder.message(outputs[0], "plain", """type, default value, row, column, degree""")

            #If a temporary variable is required, you can use the following name generator to avoid name collisions:
            #     "TmpHEBasicDec_" + self.heDec.count.str()

            #Describe deecryption fonction here

            self.heDec.outputs = outputs
            self.heDec.count = self.heDec.count + 1

        self.heDec.ope = ope

    def addHE(self) :
        """ Defines HEAdd object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            """
        self.heAdd = self.builder.heAdd()

        #Complete input and output HEAdd list with key information (type, initial value, row, column, degree).
        self.heAdd.inputs = [self.builder.message("InHEBasicAdd_c1_" + self.heAdd.count.str(), "cipher", """type, default value, row, column, degree"""), \
                    self.builder.message("InHEBasicAdd_c2_" + self.heAdd.count.str(), "cipher", """type, default value, row, column, degree""")]
        self.heAdd.outputs = [self.builder.message("OutHEBasicAdd_" + self.heAdd.count.str(), "cipher", """type, default value, row, column, degree""")]

        def ope(inputs, outputs = self.heAdd.outputs) :
            #Split the inputs list in separated parameters
            [c1, c2] = inputs

            if not(isinstance(outputs[0], Parameter)) :
                depth = max(c1.depth, c2.depth)
                #Change output HEEnc information (type, initial value, row, column, degree).
                outputs[0] = self.builder.message(outputs[0], "cipher", """type, default value, row, column, degree""")

            #If a temporary variable is required, you can use the following name generator to avoid name collisions:
            #     "TmpHEBasicAdd_" + self.heAdd.count.str()

            #Describe homomorphic addition fonction here

            self.heAdd.outputs = outputs
            self.heAdd.count = self.heAdd.count + 1

        self.heAdd.ope = ope

    def multHE(self) :
        """ Defines HEMult object which has :
            - a list of Parameter inputs
            - a function containing operation of key generation.
            - a list of Parameter outputs
            """
        self.heMult = self.builder.heMult()

        #Complete input and output HEMult list with key information (type, initial value, row, column, degree).
        self.heMult.inputs = [self.builder.message("InHEBasicMult_" + self.heMult.count.str(), "cipher", """type, default value, row, column, degree"""),\
                                self.builder.message("InHEBasicMult_" + self.heMult.count.str(), "cipher", """type, default value, row, column, degree""")]
        self.heMult.outputs = [self.builder.message("OutHEBasicMult_" + self.heMult.count.str(), "cipher", """type, default value, row, column, degree""")]

        def ope(inputs, outputs = self.heMult.outputs) :

            rlk = self.get_input("EvaluationKey_"+(self.heKeyGen.count-1).str())
            #Split the inputs list in separated parameters
            [c1, c2] = inputs

            if not(isinstance(outputs[0], Parameter)) :
                depth = max(c1.depth, c2.depth)
                #Change output HEEnc information (type, initial value, row, column, degree).
                outputs[0] = self.builder.message(outputs[0], "cipher", """type, default value, row, column, degree""")

            #If a temporary variable is required, you can use the following name generator to avoid name collisions:
            #     "TmpHEBasicMult_" + self.heMult.count.str()

            #Describe homomorphic multiplication fonction here

            #Multiplicative depth raises by 1
            outputs[0].depth = outputs[0].depth + 1

            self.heMult.outputs = outputs
            self.heMult.count = self.heMult.count + 1

        self.heMult.ope = ope

    def depth(self) :
        """Optional: calculates multiplicative depth of the scheme (thanks to a pre-calculated equation) """
        res = 0

        #Describe depth calculation here (without using Atomics or Specifics)

        return res

    def __repr__(self):
        return "SchemeName"
