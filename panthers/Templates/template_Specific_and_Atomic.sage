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


#SPECIFIC
    def make_SpecificName(self) :
        """ Build a SpecificFunction object having :
            - a list of input Parameters
            - a function containing its operations (ope function),
            - a list of output Parameters
            """
        spec = self.builder.specificFunction("""Specific function name""")

        #Create initial inputs Parameter
        #ex: q = self.builder.parameter("q","int",0,1,1,0)
        #If an input Parameter can have different types, put "NoType"
        #ex: q1 = self.builder.parameter("q1","NoType",0,1,1,0)

        inputs = ["""Fill with Parameters created (ex: q, q1)"""]
        spec.inputs = inputs

        #Retrieve Atomics that you will use in your Specific
        #template: atomic = self.finder.atomic(self.allAtomics, atomicName)
        #ex: prodScal = self.finder.atomic(self.allAtomics, "prodScal")

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                #If a temporary variable is required, you can use the following name generator to avoid name collisions:
                #     "OutSpecName_spec_" + spec.count.str()
                outputs = ["""Fill with output Parameters (as input Parameters above)"""]
                spec.count = spec.count + 1
                spec.outputs = outputs
                return outputs
            else :
                for i in range(len(outputs)) :
                    if isinstance(outputs[i], str) :
                        outputs[i] = self.builder.parameter(outputs[i],"NoType",0,1,1,0)
                return outputs

        def ope(inputs, outputs = [], count = spec.count) :
            outputs = check_outputs(outputs,count)
            spec.inputs = inputs
            #Split the inputs list in separated parameters
            ["""input parameters (ex: q, q1)"""] = spec.inputs

            #If a temporary variable is required, you can use the following name generator to avoid name collisions:
            #       "TmpSpecName_spec_" + spec.count.str()

            #Describe the specific algorithm here using Atomics and/or Specifics
            #ex: [outputs[0]] = add.ope([q1,q], [outputs[0]])


            spec.outputs = outputs
            return spec.outputs

        spec.ope = ope

        return spec

#ATOMIC
    def make_AtomicName(self) :
        """ Build a AtomicFunction object having :
            - a list of input Parameters
            - a function containing its single operation (ope function),
            - a list of output Parameters
            """
        atom = self.builder.atomicFunction("""Atomic function name""")

        #Create initial inputs Parameter
        #ex: q = self.builder.parameter("q","int",0,1,1,0)
        #If an input Parameter can have different types, put "NoType"
        #ex: q1 = self.builder.parameter("q1","NoType",0,1,1,0)

        inputs = ["""Fill with Parameters created (ex: q, q1)"""]
        atom.inputs = inputs

        def check_outputs(outputs, count) :
            if len(outputs) == 0 :
                #If a temporary variable is required, you can use the following name generator to avoid name collisions:
                #     "OutAtomName_spec_" + atom.count.str()
                outputs = ["""Fill with output Parameters (as input Parameters above)"""]
                atom.count = atom.count + 1
                atom.outputs = outputs
                return outputs
            else :
                for i in range(len(outputs)) :
                    if isinstance(outputs[i], str) :
                        outputs[i] = self.builder.parameter(outputs[i],"NoType",0,1,1,0)
                return outputs

        def ope(inputs, outputs = [], count = atom.count) :
            outputs = check_outputs(outputs,count)
            atom.inputs = inputs
            #Split the inputs list in separated parameters
            ["""input parameters (ex: q, q1)"""] = atom.inputs

            #Generally, operation of AtomicFunction are detailed in a function in ObjectOperator class.
            #Function in ObjectOperator class is called as: (replace atomOperator by the function to call)
            outputs[0] = self.operator.atomOperator(x,outputs[0])

            #If you don't want to pass by ObjectOperator, describe Atomic operations here

            atom.outputs = outputs
            return atom.outputs

        atom.ope = ope

        return atom
