#!/usr/bin/env ruby

#
# (C) Copyright 2018 - Théotime BOLLENGIER / ENSTA Bretagne.
# Contributor(s) : Théotime BOLLENGIER <theotime.bollengier@ensta-bretagne.fr> (2018)
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

require "colorize"


class Graph
	def self.shape_AND (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{32.34375*scale}"
   width="#{26.226021*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-3.0588642,-3.59375)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4544-4-8-0">
    <g
       style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
       id="g4591-7-5-4"
       transform="translate(-3)">
      <g
         style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
         id="g4564-8-0-8">
        <path
           style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
           d="M 8,30 V 10 h 35 v 20"
           id="path4503-4-96-8" />
        <path
           style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
           id="path4511-5-3-8"
           d="M 42.999383,29.995826 A 17.499794,15.068695 0 0 1 34.272442,43.107238 17.499794,15.068695 0 0 1 16.722145,43.104742 17.499794,15.068695 0 0 1 8.0002335,29.990848" />
      </g>
      <path
         id="path4513-0-8-9"
         d="M 26,45.207182 V 50"
         style="fill:none;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
      <path
         id="path4513-3-36-5-7"
         d="m 16,5 v 5"
         style="fill:none;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
      <path
         id="path4513-6-1-6-7"
         d="m 35,5 v 5"
         style="fill:none;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
    </g>
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_AND


	def self.shape_NAND (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{38.09375*scale}"
   width="#{26.226021*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-35.402614,-3.59375)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4535-0-1-6">
    <g
       id="g4564-3-6-15-4"
       style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       transform="translate(42)">
      <path
         id="path4503-6-3-9-3"
         d="M 8,30 V 10 h 35 v 20"
         style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
      <path
         d="M 42.999383,29.995826 A 17.499794,15.068695 0 0 1 34.272442,43.107238 17.499794,15.068695 0 0 1 16.722145,43.104742 17.499794,15.068695 0 0 1 8.0002335,29.990848"
         id="path4511-7-2-8-0"
         style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" />
    </g>
    <path
       style="fill:none;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 67.5,53.207182 V 58"
       id="path4513-5-0-4-3" />
    <path
       style="fill:none;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 58,5 v 5"
       id="path4513-3-3-6-8-0" />
    <path
       style="fill:none;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 77,5 v 5"
       id="path4513-6-5-1-1-9" />
    <circle
       style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       id="path4605-5-0-2"
       cx="67.5"
       cy="49.111118"
       r="3.8888888" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_NAND


	def self.shape_OR (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{33.194279*scale}"
   width="#{26.226021*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-150.40261,-6.1880577)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4808-7-8-9">
    <path
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 210,25 V 10 c 12,8 23,8 35,0 v 15 c 0,11 -8,21 -17.5,25 C 218,46 210,36 210,25 Z"
       id="path4503-6-9-7-5-8-5-3" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 227.5,50 v 4.792818"
       id="path4513-5-2-9-9-6-9-6" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 218,9 v 5"
       id="path4513-3-3-7-20-2-8-7-8" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 237,9 v 5"
       id="path4513-6-5-0-2-2-8-53-0" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_OR


	def self.shape_NOR (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{38.741055*scale}"
   width="#{26.226021*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-121.65261,-6.1880577)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4802-4-2-5">
    <path
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 170,25 V 10 c 12,8 23,8 35,0 v 15 c 0,11 -8,21 -17.5,25 C 178,46 170,36 170,25 Z"
       id="path4503-6-9-7-7-17-4" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 187.49402,57.71725 v 4.792818"
       id="path4513-5-2-9-4-8-8" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 178,9 v 5"
       id="path4513-3-3-7-20-4-5-1" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 197,9 v 5"
       id="path4513-6-5-0-2-3-74-2" />
    <circle
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       id="path4605-9-6-7-0-1-8"
       cx="187.47667"
       cy="54.111118"
       r="3.8888888" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_NOR


	def self.shape_XOR (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{35.788589*scale}"
   width="#{26.226021*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-92.902615,-3.59375)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4795-3-3-9">
    <path
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 130,25 V 10 c 12,8 23,8 35,0 v 15 c 0,11 -8,21 -17.5,25 C 138,46 130,36 130,25 Z"
       id="path4503-6-9-0-7-1-2" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 147.5,50 v 4.792818"
       id="path4513-5-2-6-4-7-2" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 138,5 v 9"
       id="path4513-3-3-7-2-5-5-4" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 157,5 v 9"
       id="path4513-6-5-0-6-2-9-7" />
    <path
       style="fill:none;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 130,6 c 12,8 23,8 35,0"
       id="path4503-6-9-3-1-5-6-7" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_XOR


	def self.shape_XNOR (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{41.335361*scale}"
   width="#{26.226021*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-64.152615,-3.59375)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4788-5-3-5">
    <path
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 90,25 V 10 c 12,8 23,8 35,0 v 15 c 0,11 -8,21 -17.5,25 C 98,46 90,36 90,25 Z"
       id="path4503-6-9-4-04-4" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 107.49402,57.71725 v 4.792818"
       id="path4513-5-2-7-4-0" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 98,5 v 9"
       id="path4513-3-3-7-6-4-5" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 117,5 v 9"
       id="path4513-6-5-0-5-4-9" />
    <path
       style="fill:none;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 90,6 c 12,8 23,8 35,0"
       id="path4503-6-9-3-6-7-4" />
    <circle
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       id="path4605-9-6-9-6-6"
       cx="107.47667"
       cy="54.111118"
       r="3.8888888" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_XNOR


	def self.shape_INVERTER (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{34.202175*scale}"
   width="#{23.268555*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-186.02197,-7.3364121)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4814-4-8-2">
    <path
       style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 260,15 15,31 15,-31 z"
       id="path4723-3-8-1" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 275,53 v 4.792818"
       id="path4513-5-2-9-97-1-3-0" />
    <circle
       style="fill:#e3e3e3;fill-opacity:1;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       id="path4605-9-6-7-3-4-1-5"
       cx="274.98267"
       cy="49.393867"
       r="3.8888888" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 275,10.207182 V 15"
       id="path4513-5-2-9-97-6-9-89-1" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_INVERTER


	def self.shape_BUFFER (scale = 1.0)
		return <<EOS
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   id="svg6"
   version="1.1"
   height="#{34.202175*scale}"
   width="#{23.268555*scale}">
  <metadata
     id="metadata12">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs10" />
  <g transform="scale(#{scale}, #{scale})">
  <g
     transform="matrix(0.71875,0,0,0.71875,-211.17822,-1.919074)"
     style="stroke-width:1.48837638;stroke-miterlimit:4;stroke-dasharray:none"
     id="g4819-2-6-1">
    <path
       style="fill:#e3e3e3;fill-opacity:1;stroke:#000000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 295,15 15,31 15,-31 z"
       id="path4723-1-0-4-0" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="m 310,45.462833 v 4.792818"
       id="path4513-5-2-9-97-2-6-3-8" />
    <path
       style="fill:none;stroke:#0f0000;stroke-width:1.48837638;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
       d="M 310,10.207182 V 15"
       id="path4513-5-2-9-97-6-3-8-33-5" />
  </g>
  </g>
</svg>
EOS
	end # Graph::shape_BUFFER


	class Vertice
		attr_accessor :inputs, :outputs, :netlist_node, :tmp_number, :layer

		def initialize (netlist_node = nil)
			if netlist_node.nil? then
				@netlist_node = nil
				@inputs = nil
				@outputs = nil
			else
				@netlist_node = netlist_node
				@inputs = @netlist_node.inputs.collect{|e| e}
				@outputs = @netlist_node.fanouts.collect{|e| e}
				@inputs = [] if self.kind_of?(Graph::Input)
				@outputs = [] if self.kind_of?(Graph::Output)
			end
			@tmp_number = nil
			@layer = nil
		end

		def clone
			c = self.class.new
			c.inputs = @inputs.collect{|e| e}
			c.outputs = @outputs.collect{|e| e}
			c.netlist_node = @netlist_node
			c.tmp_number = @tmp_number
			return c
		end

		def to_s
			"#{self.class.name.gsub(/^Graph::/,'')}[#{@netlist_node.class.name.gsub(/^GateNetlist::/,'')}: #{@netlist_node.name}]"
		end

		def to_graphviz (custom_images = false)
			if custom_images then
				"\t#{@tmp_number.to_s.ljust(5)} [shape=\"#{graphviz_shape}\",color=\"#{graphviz_color}\"#{graphviz_fillcolor ? ",style=\"filled\",fillcolor=\"#{graphviz_fillcolor}\"":''},label=\"#{@layer ? "#{@layer}\\n":''}#{@netlist_node.name}\"];\n"
			else
				"\t#{@tmp_number.to_s.ljust(5)} [shape=\"#{graphviz_shape}\",color=\"#{graphviz_color}\"#{graphviz_fillcolor ? ",style=\"filled\",fillcolor=\"#{graphviz_fillcolor}\"":''},label=\"#{@layer ? "#{@layer}\\n":''}#{@netlist_node.class.name.gsub(/^GateNetlist::/,'')}\\n#{@netlist_node.name}\"];\n"
			end
		end

		def graphviz_shape
			"oval"
		end

		def graphviz_color
			"black"
		end

		def graphviz_fillcolor
			nil
		end

		def has_custom_shape?
			return (@netlist_node.class == GateNetlist::Xnor or
					@netlist_node.class == GateNetlist::Xor or
					@netlist_node.class == GateNetlist::Nor or
					@netlist_node.class == GateNetlist::Or or
					@netlist_node.class == GateNetlist::Nand or
					@netlist_node.class == GateNetlist::And or
					@netlist_node.class == GateNetlist::Inverter or
					@netlist_node.class == GateNetlist::Buffer)
		end
	end

	class Gate < Graph::Vertice
		def initialize (nn = nil)
			super(nn)
		end

		def graphviz_fillcolor
			"gray89"
		end

		def to_graphviz (custom_images = false)
			if custom_images and has_custom_shape? then
				#"\t#{@tmp_number.to_s.ljust(5)} [shape=\"#{graphviz_shape}\",color=\"#{graphviz_color}\"#{graphviz_fillcolor ? ",style=\"filled\",fillcolor=\"#{graphviz_fillcolor}\"":''},headport=\"e\",tailport=\"w\",label=\"#{@layer ? "#{@layer}\\n":''}#{@netlist_node.name}\"];\n"
				#"\t#{@tmp_number.to_s.ljust(5)} [image=\"shadok.svg\",penwidth=0,label=\"#{@layer ? "#{@layer}\\n":''}#{@netlist_node.class.name.gsub(/^GateNetlist::/,'')}\\n#{@netlist_node.name}\"];\n"
				#"\t#{@tmp_number.to_s.ljust(5)} [image=\"#{@netlist_node.class.name.sub(/^.*?::/, '').downcase}.svg\",penwidth=0,label=\"#{@layer ? "#{@layer}\\n":''}#{@netlist_node.name}\"];\n"
				"\t#{@tmp_number.to_s.ljust(5)} [image=\"#{@netlist_node.class.name.sub(/^.*?::/, '').downcase}.svg\",penwidth=0,label=\"\"];\n"
			else
				return super (custom_images)
			end
		end
	end

	class Input < Graph::Vertice
		def initialize (nn = nil)
			super(nn)
		end
	end

	class Output < Graph::Vertice
		def initialize (nn = nil)
			super(nn)
		end
	end

	class PrimaryInput < Graph::Input
		def initialize (nn = nil)
			super(nn)
		end

		def graphviz_shape
			#"invtriangle"
			"invhouse"
		end

		def graphviz_color
			"green"
		end

		def graphviz_fillcolor
			"palegreen"
		end
	end

	class PrimaryOutput < Graph::Output
		def initialize (nn = nil)
			super(nn)
		end

		def graphviz_shape
			#"invtriangle"
			"invhouse"
		end

		def graphviz_color
			"red"
		end

		def graphviz_fillcolor
			"indianred1"
		end
	end

	class LatchOutput < Graph::Input
		def initialize (nn = nil)
			super(nn)
		end

		def graphviz_shape
			#"invhouse"
			"invtrapezium"
		end

		def graphviz_color
			"dodgerblue2"
		end

		def graphviz_fillcolor
			"lightblue"
		end
	end

	class LatchInput < Graph::Output
		def initialize (nn = nil)
			super(nn)
		end

		def graphviz_shape
			#"invhouse"
			"invtrapezium"
		end

		def graphviz_color
			"blue"
		end

		def graphviz_fillcolor
			"lightblue"
		end
	end


	attr_accessor :vertices


	def initialize (gate_netlist = nil)
		@vertices = []

		return if gate_netlist.nil?

		gate_netlist.nodes.each do |gnn|
			case gnn
			when GateNetlist::Input
				@vertices << Graph::PrimaryInput.new(gnn)
			when GateNetlist::Output
				@vertices << Graph::PrimaryOutput.new(gnn)
			when GateNetlist::Const0
				@vertices << Graph::PrimaryInput.new(gnn)
			when GateNetlist::Const1
				@vertices << Graph::PrimaryInput.new(gnn)
			when GateNetlist::Latch
				@vertices << Graph::LatchInput.new(gnn)
				@vertices << Graph::LatchOutput.new(gnn)
			else
				@vertices << Graph::Gate.new(gnn)
			end
		end

		gnn_vert_hash = {}
		@vertices.select{|v| not(v.kind_of?(Graph::LatchInput)) and not(v.kind_of?(Graph::LatchOutput))}.each{|v| gnn_vert_hash[v.netlist_node] = v}
		gnn_latch_input_hash  = {}
		@vertices.select{|v| v.kind_of?(Graph::LatchInput)}.each{|v| gnn_latch_input_hash[v.netlist_node] = v}
		gnn_latch_output_hash = {}
		@vertices.select{|v| v.kind_of?(Graph::LatchOutput)}.each{|v| gnn_latch_output_hash[v.netlist_node] = v}

		@vertices.each do |v|
			inputs = v.inputs.collect do |gnn|
				if gnn.kind_of?(GateNetlist::Latch) then
					gnn_latch_output_hash[gnn]
				else
					gnn_vert_hash[gnn]
				end
			end

			outputs = v.outputs.collect do |gnn|
				if gnn.kind_of?(GateNetlist::Latch) then
					gnn_latch_input_hash[gnn]
				else
					gnn_vert_hash[gnn]
				end
			end

			v.inputs = inputs
			v.outputs = outputs
		end
	end # Graph#initilize


	def clone
		g = Graph.new
		@vertices.each_with_index{|v, i| v.tmp_number = i}
		g.vertices = @vertices.collect{|v| v.clone}
		g.vertices.each do |v|
			v.inputs  = v.inputs.collect{|ov| g.vertices[ov.tmp_number]}
			v.outputs = v.outputs.collect{|ov| g.vertices[ov.tmp_number]}
		end
		return g
	end # Graph#clone


	def connected_subgraphs
		verticePool = {}
		@vertices.each{|v| verticePool[v] = v}
		dags = []
		while v = verticePool.values.find{|vtx| not(vtx.kind_of?(Graph::Input) or vtx.kind_of?(Graph::Output))} do
			nvh = {}
			Graph.get_connected_vertices_recursive(v, nvh, verticePool)
			nvh.each do |k, v|
				next unless k.kind_of?(Graph::Input)
				k.outputs = k.outputs.reject{|o| nvh[o].nil?}
			end
			g = Graph.new
			g.vertices = nvh.values
			dags << g.clone
		end
		return dags
	end # Graph::connected_subgraphs


	def is_acyclic?
		# If a directed graph is acyclic, it has at least a node with no successors,
		# if there is no such node, then the graph cannot be acyclic.
		# If we remove a node with no successors, the graph is still acyclic as it leaves new nodes without successors

		graph = self.clone

		until graph.vertices.empty? do
			# Find a leaf, e.g. a node with no successors
			leaf = graph.vertices.find{|v| v.outputs.empty?}
			return false if leaf.nil?
			graph.vertices.delete(leaf)
			leaf.inputs.each do |i|
				i.outputs.delete(leaf)
			end
		end

		return true
	end # Graph#is_acyclic?


	def to_graphviz (outFileName, custom_images = false)
		@vertices.each_with_index{|v, i| v.tmp_number = i}

		ofile = File.open(outFileName, "w")

		ofile.puts "digraph G {"
		ofile.puts "\tgraph [fontname = \"Sans\"];"
		ofile.puts "\tnode  [fontname = \"Sans\"];"
		ofile.puts "\tedge  [fontname = \"Sans\"];"
		ofile.puts
		@vertices.each{|v| ofile.puts v.to_graphviz(custom_images)}
		ofile.puts
		@vertices.each do |v|
			next if v.kind_of?(Graph::Output)
			v.outputs.each do |o|
				str = "\t#{v.tmp_number} -> #{o.tmp_number}"
				#str += ' [tailport="s"]' if v.has_custom_shape?
				str += ';'
				ofile.puts str
			end
		end
		ofile.puts
		ofile.puts "\t{rank=same; #{@vertices.select{|v| v.kind_of?(Graph::Input)}.collect{|v| v.tmp_number.to_s}.join(' ')}};"
		ofile.puts "\t{rank=same; #{@vertices.select{|v| v.kind_of?(Graph::Output)}.collect{|v| v.tmp_number.to_s}.join(' ')}};"
		ofile.puts "}"

		ofile.close
	end # Graph#to_graphviz


	def collect_used_custom_shapes
		return @vertices.select{|v| v.has_custom_shape?}.collect{|v| v.netlist_node.class.name.sub(/^GateNetlist::/,'').downcase}.uniq
	end # Graph#collect_used_custom_shapes


	def assign_layers_to_vertices
		# The Longest-Path Algorithm
		abort "Cannot layer cyclic graph!".light_red unless self.is_acyclic?

		v_remainder_set = @vertices.collect{|v| v.layer = nil; v}
		u_set_length = 0
		currentLayer = 0
		while u_set_length != @vertices.length do
			selectedVertice = nil
			v_remainder_set.each do |v|
				unless v.inputs.collect{|o| o.layer != nil and o.layer < currentLayer}.include?(false)
					selectedVertice = v
					break;
				end
			end
			if selectedVertice.nil? then
				currentLayer += 1
			else
				selectedVertice.layer = currentLayer
				u_set_length += 1
				v_remainder_set.delete(selectedVertice)
			end
		end
		self
	end # Graph#assign_layers_to_vertices


	private


	def self.get_connected_vertices_recursive (vertice, nvh, verticePool)
		return if nvh[vertice]
		nvh[vertice] = vertice
		raise "Mah! Que passa ?".light_red unless verticePool[vertice]
		verticePool.delete(vertice) unless vertice.kind_of?(Graph::Input) or vertice.kind_of?(Graph::Output)
		vertice.inputs.each{|v| Graph.get_connected_vertices_recursive(v, nvh, verticePool)}
		vertice.outputs.each{|v| Graph.get_connected_vertices_recursive(v, nvh, verticePool)}
	end # Graph::get_connected_vertices_recursive

end # Graph


class GateNetlist

	class Node
		attr_accessor :inputs, :fanouts, :name

		def initialize (inputs: [], output: nil)
			@inputs = inputs
			@fanouts = []
			if self.kind_of?(GateNetlist::Output) then
				@name = inputs[0]
			else
				@name = output
			end
		end # GateNetlist::Node#initialize

		def fanout
			return @fanout[0]
		end # GateNetlist::Node#fanout

		def input
			return @inputs[0] if @inputs.length < 2
			return @inputs
		end # GateNetlist::Node#input

		def pname
			return @name.gsub('[', '_').gsub(']', '')
		end

		def to_piccolo
			abort "#{self.class.name} is not to be expressed as a Piccolo expression!".light_red
		end
	end # GateNetlist::Node


	class Input < GateNetlist::Node
		attr_accessor :iname
		def initialize (output)
			super(output: output)
			@iname = nil
			@iname = output if output.kind_of?(String)
		end # GateNetlist::Input#initialize

		def to_piccolo
			return "input  #{iname}"
		end # GateNetlist::Input#to_piccolo

		def to_explicit_netlist
			"#{pname} = ENC(#{iname}_input);"
		end
	end # GateNetlist::Input


	class Output < GateNetlist::Node
		attr_accessor :oname
		def initialize (input)
			super(inputs: [input])
			@oname = nil
			@oname = input if input.kind_of?(String)
		end # GateNetlist::Output#initialize


		def to_piccolo
			return "output #{pname}"
		end # GateNetlist::Output#to_piccolo

		def to_explicit_netlist
			"#{oname}_output = DEC(#{pname});"
		end
	end # GateNetlist::Input


	class Const0 < GateNetlist::Node
		def initialize (output)
			super(output: output)
		end # GateNetlist::Const0#initialize

		def to_s
			return "#{@name} = 0;"
		end

		def to_piccolo
			return "\t#{pname} = 1b0;"
		end

		def to_explicit_netlist
			"#{pname} = 0;"
		end
	end # GateNetlist::Const0


	class Const1 < GateNetlist::Node
		def initialize (output)
			super(output: output)
		end # GateNetlist::Const1#initialize

		def to_s
			return "#{@name} = 1;"
		end

		def to_piccolo
			return "\t#{pname} = 1b1;"
		end

		def to_explicit_netlist
			"#{pname} = 1;"
		end
	end # GateNetlist::Const1


	class Latch < GateNetlist::Node
		def initialize (input, output)
			super(inputs: [input], output: output)
		end # GateNetlist::Latch#initialize

		def to_s
			return "#{@name} = latch(#{@input[0].name});"
		end

		def to_piccolo
			return "\t#{pname} = #{input.pname}; // reg"
		end
	end # GateNetlist::Latch


	class Buffer < GateNetlist::Node
		def initialize (input, output)
			super(inputs: [input], output: output)
		end # GateNetlist::Buffer#initialize

		def to_s
			return "#{@name} = #{@inputs[0].name};"
		end

		def to_piccolo
			return "\t#{pname} = #{input.pname};"
		end

		def to_explicit_netlist
			"#{pname} = #{input.pname};"
		end
	end # GateNetlist::Buffer


	class Inverter < GateNetlist::Node
		def initialize (input, output)
			super(inputs: [input], output: output)
		end # GateNetlist::Inverter#initialize

		def to_s
			return "#{@name} = not(#{@inputs[0].name});"
		end

		def to_piccolo
			return "\t#{pname} = ~#{input.pname};"
		end

		def to_explicit_netlist
			"#{pname} = NOT(#{input.pname});"
		end
	end # GateNetlist::Inverter


	class And < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::And#initialize

		def to_s
			return "#{@name} = and(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = #{@inputs.collect{|n| n.pname}.join(' & ')};"
		end

		def to_explicit_netlist
			"#{pname} = AND(#{@inputs.collect{|n| n.pname}.join(', ')});"
		end
	end # GateNetlist::And


	class Nand < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Nand#initialize

		def to_s
			return "#{@name} = nand(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~(#{@inputs.collect{|n| n.pname}.join(' & ')});"
		end

		def to_explicit_netlist
			"#{pname} = NAND(#{@inputs.collect{|n| n.pname}.join(', ')});"
		end
	end # GateNetlist::Nand


	class Or < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Or#initialize

		def to_s
			return "#{@name} = or(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = #{@inputs.collect{|n| n.pname}.join(' | ')};"
		end

		def to_explicit_netlist
			"#{pname} = OR(#{@inputs.collect{|n| n.pname}.join(', ')});"
		end
	end # GateNetlist::Or


	class Nor < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Nor#initialize

		def to_s
			return "#{@name} = nor(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~(#{@inputs.collect{|n| n.pname}.join(' | ')});"
		end

		def to_explicit_netlist
			"#{pname} = NOR(#{@inputs.collect{|n| n.pname}.join(', ')});"
		end
	end # GateNetlist::Nor


	class Xor < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Xor#initialize

		def to_s
			return "#{@name} = xor(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = #{@inputs.collect{|n| n.pname}.join(' ^ ')};"
		end

		def to_explicit_netlist
			"#{pname} = XOR(#{@inputs.collect{|n| n.pname}.join(', ')});"
		end
	end # GateNetlist::Xor


	class Xnor < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Xnor#initialize

		def to_s
			return "#{@name} = xnor(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~(#{@inputs.collect{|n| n.pname}.join(' ^ ')});"
		end

		def to_explicit_netlist
			"#{pname} = XNOR(#{@inputs.collect{|n| n.pname}.join(', ')});"
		end
	end # GateNetlist::Xnor


	class Aoi21 < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Aoi21#initialize

		def to_s
			return "#{@name} = aoi21(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~((#{@inputs[0].pname} & #{@inputs[1].pname}) | #{@inputs[2].pname});"
		end
	end # GateNetlist::Aoi21


	class Aoi22 < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Aoi22#initialize

		def to_s
			return "#{@name} = aoi22(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~((#{@inputs[0].pname} & #{@inputs[1].pname}) | (#{@inputs[2].pname} & #{@inputs[3].pname}));"
		end
	end # GateNetlist::Aoi22


	class Oai21 < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Oai21#initialize

		def to_s
			return "#{@name} = oai21(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~((#{@inputs[0].pname} | #{@inputs[1].pname}) & #{@inputs[2].pname});"
		end
	end # GateNetlist::Oai21


	class Oai22 < GateNetlist::Node
		def initialize (inputs, output)
			super(inputs: inputs, output: output)
		end # GateNetlist::Oai22#initialize

		def to_s
			return "#{@name} = oai22(#{@inputs.collect{|n| n.name}.join(', ')});"
		end

		def to_piccolo
			return "\t#{pname} = ~((#{@inputs[0].pname} | #{@inputs[1].pname}) & (#{@inputs[2].pname} | #{@inputs[3].pname}));"
		end
	end # GateNetlist::Oai22


	attr_reader :nodes


	def initialize (fname = nil)
		@node_hash = {} # {name => node}
		@nodes = []
		return if fname.nil?
		parse_mapped_blif(fname)
	end # GateNetlist#initialize


	def parse_mapped_blif (fname)
		@node_hash = {} # {name => node}
		@nodes = []
		content = nil
		begin
			content = File.read(fname).gsub(/\s\\\n/, " ").gsub(/^\s+/, '').gsub(/^#.*$/, '').gsub(/\n+/, "\n").gsub(/[ \t]+/, ' ').gsub(/\n([01]+( [01])?)/, ' # \1')
		rescue => e
			abort e.message.light_red
		end

		stop = false
		content.each_line do |l|
			break if stop
			l.chomp!
			next if l.empty?

			case l
			when /^\.model\s+([^\s]+)$/
				@name = $1
			when /^\.inputs\s+(.+)$/
				$1.split(/\s+/).each{|n| add_node GateNetlist::Input.new(n)}
			when /^\.outputs\s+(.+)$/
				$1.split(/\s+/).each{|n| add_node GateNetlist::Output.new(n)}
			when /^\.latch\s+([^\s]+)\s+([^\s]+)\s+.*$/
				add_node GateNetlist::Latch.new($1, $2)
			when /^\.gate\s+buf\s+I0=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Buffer.new($1, $2)
			when /^\.gate\s+inv\s+I0=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Inverter.new($1, $2)
			when /^\.gate\s+and\s+I0=([^\s]+)\s+I1=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::And.new([$1, $2], $3)
			when /^\.gate\s+nand\s+I0=([^\s]+)\s+I1=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Nand.new([$1, $2], $3)
			when /^\.gate\s+or\s+I0=([^\s]+)\s+I1=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Or.new([$1, $2], $3)
			when /^\.gate\s+nor\s+I0=([^\s]+)\s+I1=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Nor.new([$1, $2], $3)
			when /^\.gate\s+xor\s+I0=([^\s]+)\s+I1=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Xor.new([$1, $2], $3)
			when /^\.gate\s+xnor\s+I0=([^\s]+)\s+I1=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Xnor.new([$1, $2], $3)
			when /^\.gate\s+and(\d+)\s+(.+?)\s+O=([^\s]+)$/
				nb_inputs = $1.to_i
				output = $3
				inputs = $2.split(/\s*I\d+=/).reject{|e| e.empty?}
				if nb_inputs != inputs.length then
					abort "inputs: #{inputs.inspect}, \"#{l}\"".light_red
				end
				add_node GateNetlist::And.new(inputs, output)
			when /^\.gate\s+nand(\d+)\s+(.+?)\s+O=([^\s]+)$/
				nb_inputs = $1.to_i
				output = $3
				inputs = $2.split(/\s*I\d+=/).reject{|e| e.empty?}
				if nb_inputs != inputs.length then
					abort "inputs: #{inputs.inspect}, \"#{l}\"".light_red
				end
				add_node GateNetlist::Nand.new(inputs, output)
			when /^\.gate\s+or(\d+)\s+(.+?)\s+O=([^\s]+)$/
				nb_inputs = $1.to_i
				output = $3
				inputs = $2.split(/\s*I\d+=/).reject{|e| e.empty?}
				if nb_inputs != inputs.length then
					abort "inputs: #{inputs.inspect}, \"#{l}\"".light_red
				end
				add_node GateNetlist::Or.new(inputs, output)
			when /^\.gate\s+nor(\d+)\s+(.+?)\s+O=([^\s]+)$/
				nb_inputs = $1.to_i
				output = $3
				inputs = $2.split(/\s*I\d+=/).reject{|e| e.empty?}
				if nb_inputs != inputs.length then
					abort "inputs: #{inputs.inspect}, \"#{l}\"".light_red
				end
				add_node GateNetlist::Nor.new(inputs, output)
			when /^\.end$/
				stop = true
			when /^\.gate\s+cst0\s+O=([^\s]+)$/
				add_node GateNetlist::Const0.new($1)
			when /^\.gate\s+cst1\s+O=([^\s]+)$/
				add_node GateNetlist::Const1.new($1)
			when /^\.gate\s+aoi21\s+I0=([^\s]+)\s+I1=([^\s]+)\s+I2=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Aoi21.new([$1, $2, $3], $4)
			when /^\.gate\s+aoi22\s+I0=([^\s]+)\s+I1=([^\s]+)\s+I2=([^\s]+)\s+I3=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Aoi22.new([$1, $2, $3, $4], $5)
			when /^\.gate\s+oai21\s+I0=([^\s]+)\s+I1=([^\s]+)\s+I2=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Oai21.new([$1, $2, $3], $4)
			when /^\.gate\s+oai22\s+I0=([^\s]+)\s+I1=([^\s]+)\s+I2=([^\s]+)\s+I3=([^\s]+)\s+O=([^\s]+)$/
				add_node GateNetlist::Oai22.new([$1, $2, $3, $4], $5)
			### simple recognizable .names ###
			when /^\.names\s+([^\s]+)\s+([^\s]+) # 0 1$/
				add_node GateNetlist::Inverter.new($1, $2)
			when /^\.names\s+([^\s]+)\s+([^\s]+) # 1 1$/
				add_node GateNetlist::Buffer.new($1, $2)
			when /^\.names\s+([^\s]+)$/
				add_node GateNetlist::Const0.new($1)
			when /^\.names\s+([^\s]+) # 0$/
				add_node GateNetlist::Const0.new($1)
			when /^\.names\s+([^\s]+) # 1$/
				add_node GateNetlist::Const1.new($1)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 11 1$/
				add_node GateNetlist::And.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 1- 1 # -1 1$/
				add_node GateNetlist::Or.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # -1 1 # 1- 1$/
				add_node GateNetlist::Or.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 00 0$/
				add_node GateNetlist::Or.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 10 1 # 01 1$/
				add_node GateNetlist::Xor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 01 1 # 10 1$/
				add_node GateNetlist::Xor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 11 0 # 00 0$/
				add_node GateNetlist::Xor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 00 0 # 11 0$/
				add_node GateNetlist::Xor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 11 0$/
				add_node GateNetlist::Nand.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 00 1$/
				add_node GateNetlist::Nor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 00 1 # 11 1$/
				add_node GateNetlist::Xnor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 11 1 # 00 1$/
				add_node GateNetlist::Xnor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 01 0 # 10 0$/
				add_node GateNetlist::Xnor.new([$1, $2], $3)
			when /^\.names\s+([^\s]+)\s+([^\s]+)\s+([^\s]+) # 10 0 # 01 0$/
				add_node GateNetlist::Xnor.new([$1, $2], $3)
			else
				abort "ERROR file \"#{fname}\": cannot parse \"#{l}\"".light_yellow
			end
		end

		@nodes.each do |node|
			#node.inputs = node.inputs.collect{|iname| node.input_hash[iname] = @node_hash[iname]}
			node.inputs = node.inputs.collect{|iname| @node_hash[iname]}
			abort "node #{node.name}: inputs: #{node.inputs.collect{|i| i.class.name}}".light_red if node.inputs.count{|i| not(i.kind_of?(GateNetlist::Node))} > 0
		end

		@nodes.each do |node|
			#node.fanouts = @nodes.select{|nn| nn.input_hash[node.name]}
			node.fanouts = @nodes.select{|nn| nn.inputs.include?(node)}
			abort "node #{node.name}: fanouts: #{node.fanouts.collect{|i| i.class.name}}".light_red if node.fanouts.count{|i| not(i.kind_of?(GateNetlist::Node))} > 0
			#puts node.fanouts.collect{|n| n.name}.inspect
		end

		@nodes.delete_if{|node| node.fanouts.empty? and not(node.kind_of?(GateNetlist::Output))}
		@nodes.delete_if{|node| node.inputs.empty? and not(node.kind_of?(GateNetlist::Input) or node.kind_of?(GateNetlist::Const0) or node.kind_of?(GateNetlist::Const1))}
	end # GateNetlist#parse_mapped_blif


	def analyze
		nb_inputs = @nodes.count{|e| e.kind_of?(GateNetlist::Input)}
		nb_outputs = @nodes.count{|e| e.kind_of?(GateNetlist::Output)}
        nb_latches = @nodes.count{|e| e.kind_of?(GateNetlist::Latch)}
        nb_buffers = @nodes.count{|e| e.kind_of?(GateNetlist::Buffer)}
        nb_inverters = @nodes.count{|e| e.kind_of?(GateNetlist::Inverter)}
        nb_ands = @nodes.count{|e| e.kind_of?(GateNetlist::And)}
        nb_nands = @nodes.count{|e| e.kind_of?(GateNetlist::Nand)}
        nb_ors = @nodes.count{|e| e.kind_of?(GateNetlist::Or)}
        nb_nors = @nodes.count{|e| e.kind_of?(GateNetlist::Nor)}
        nb_xors = @nodes.count{|e| e.kind_of?(GateNetlist::Xor)}
        nb_xnors = @nodes.count{|e| e.kind_of?(GateNetlist::Xnor)}
        nb_cst0 = @nodes.count{|e| e.kind_of?(GateNetlist::Const0)}
        nb_cst1 = @nodes.count{|e| e.kind_of?(GateNetlist::Const1)}
        nb_aoi21 = @nodes.count{|e| e.kind_of?(GateNetlist::Aoi21)}
        nb_aoi22 = @nodes.count{|e| e.kind_of?(GateNetlist::Aoi22)}
        nb_oai21 = @nodes.count{|e| e.kind_of?(GateNetlist::Oai21)}
        nb_oai22 = @nodes.count{|e| e.kind_of?(GateNetlist::Oai22)}
		nb_gates = nb_inverters + nb_ands + nb_nands + nb_ors + nb_nors + nb_xors + nb_xnors + nb_cst0 + nb_cst1 + nb_aoi21 + nb_aoi22 + nb_oai21 + nb_oai22

		str  = "Module \"#{@name}\"\n"
		str += " Inputs:   #{nb_inputs.to_s.rjust(4)}\n" if nb_inputs > 0
		str += " Outputs:  #{nb_outputs.to_s.rjust(4)}\n" if nb_outputs > 0
		str += " Latches:  #{nb_latches.to_s.rjust(4)}\n" if nb_latches > 0
		str += " Gates:    #{nb_gates.to_s.rjust(4)}\n" if nb_gates > 0
		str += "  buf:     #{nb_buffers.to_s.rjust(4)}\n" if nb_buffers > 0
		str += "  inv:     #{nb_inverters.to_s.rjust(4)}\n" if nb_inverters > 0
		str += "  and:     #{nb_ands.to_s.rjust(4)}\n" if nb_ands > 0
		str += "  nand:    #{nb_nands.to_s.rjust(4)}\n" if nb_nands > 0
		str += "  or:      #{nb_ors.to_s.rjust(4)}\n" if nb_ors > 0
		str += "  nor:     #{nb_nors.to_s.rjust(4)}\n" if nb_nors > 0
		str += "  xor:     #{nb_xors.to_s.rjust(4)}\n" if nb_xors > 0
		str += "  xnor:    #{nb_xnors.to_s.rjust(4)}\n" if nb_xnors > 0
		str += "  const 0: #{nb_cst0.to_s.rjust(4)}\n" if nb_cst0 > 0
		str += "  const 1: #{nb_cst1.to_s.rjust(4)}\n" if nb_cst1 > 0
		str += "  aoi21:   #{nb_aoi21.to_s.rjust(4)}\n" if nb_aoi21 > 0
		str += "  aoi22:   #{nb_aoi22.to_s.rjust(4)}\n" if nb_aoi22 > 0
		str += "  oai21:   #{nb_aoi21.to_s.rjust(4)}\n" if nb_oai21 > 0
		str += "  oai22:   #{nb_aoi22.to_s.rjust(4)}\n" if nb_oai22 > 0
		return str
	end # GateNetlist#analyze


	def to_file (outfname)
		ofile = File.open(outfname, 'w')
		ofile.puts "model(\"#{@name}\")"
		ofile.puts "inputs(#{@nodes.select{|n| n.kind_of?(GateNetlist::Input)}.collect{|n| n.name}.join(', ')})"
		ofile.puts "outputs(#{@nodes.select{|n| n.kind_of?(GateNetlist::Output)}.collect{|n| n.name}.join(', ')})"
		@nodes.reject{|n| n.kind_of?(GateNetlist::Input) or n.kind_of?(GateNetlist::Output)}.each do |node|
			ofile.puts node.to_s
		end
		ofile.close
	end # GateNetlist#to_file


	def to_piccolo (outfname)
		ofile = File.open(outfname, 'w')
		ofile.puts
		str = "module #{@name}("
		ofile.write str

		l = str.length
		inputs = @nodes.select{|n| n.kind_of?(GateNetlist::Input)}.collect{|input| input.to_piccolo}
		outputs = @nodes.select{|n| n.kind_of?(GateNetlist::Output)}.collect{|output| output.to_piccolo}
		ofile.write (inputs + outputs).join(",\n" + ' '*l)
		ofile.puts ") :"

		reg_to_outputs = []
		@nodes.select{|n| n.kind_of?(GateNetlist::Latch)}.each do |latch|
			if latch.fanouts.count{|fanout| fanout.kind_of?(GateNetlist::Output)} > 0 then
				name = latch.pname
				latch.name = name + "_reg_to_output"
				reg_to_outputs << [name, latch.pname]
			end
		end

		regs = @nodes.select{|n| n.kind_of?(GateNetlist::Latch)}.collect{|latch| "\treg  #{latch.pname}"}
		wires = @nodes.reject{|n| n.kind_of?(GateNetlist::Latch) or n.kind_of?(GateNetlist::Input) or n.kind_of?(GateNetlist::Output) or n.fanouts.count{|f| f.kind_of?(GateNetlist::Output)} > 0}.collect{|net| "\twire #{net.pname}"}

		ofile.puts (regs + wires).join(",\n")

		ofile.puts '{'

		@nodes.reject{|n| n.kind_of?(GateNetlist::Input) or n.kind_of?(GateNetlist::Output)}.each do |node|
			ofile.puts node.to_piccolo
		end

		ofile.puts() unless reg_to_outputs.empty?
		reg_to_outputs.each do |lhs_rhs|
			ofile.puts "\t#{lhs_rhs[0]} = #{lhs_rhs[1]};"
		end


		ofile.puts '}'
		ofile.puts

		ofile.close
	end # GateNetlist#to_piccolo


	def test
		graph = Graph.new(self)
		graph.vertices.each{|n| puts n}
	end # GateNetlist#test


	def to_graph
		return Graph.new(self)
	end # GateNetlist#to_graph


	def to_explicit_netlist (outFileName)
		ofile = nil
		begin
			ofile = File.open(outFileName, 'w')
		rescue => e
			abort "Cannot open file \"#{outFileName}\" for writing: #{e.message}".light_red
		end

		graphs = self.to_graph.connected_subgraphs
		graphs.each{|g| g.assign_layers_to_vertices}
		max_layer = graphs.collect{|g| g.vertices.collect{|v| v.layer}.max}.max

		@nodes.select{|n| n.kind_of?(GateNetlist::Input)}.each do |input|
			ofile.puts input.to_explicit_netlist
		end
		ofile.puts

		layered_nodes = graphs.collect{|g| g.vertices.sort_by{|v| v.layer}.collect{|v| v.netlist_node}}.flatten.reject{|n| n.kind_of?(GateNetlist::Input) or n.kind_of?(GateNetlist::Output)}
		layered_nodes.each do |n|
			ofile.puts n.to_explicit_netlist
		end
		ofile.puts
		@nodes.select{|n| n.kind_of?(GateNetlist::Output)}.each do |output|
			ofile.puts output.to_explicit_netlist
		end
		ofile.close
	end # GateNetlist#to_explicit_netlist


	private

	def add_node (node)
		unless node.kind_of?(GateNetlist::Output) then
			abort "ERROR: net \"#{node.name}\" has more than one driver!\n@nodes = #{@node_hash.inspect}\nnode = #{node.inspect}".light_red unless @node_hash[node.name].nil?
			@node_hash[node.name] = node
		end
		@nodes << node
	end
end # GateNetlist



if $0 == __FILE__ then
	require 'optparse'
	require 'tmpdir'
	require 'fileutils'


	def execute_program (pgname, argument_line)
		res = system(pgname + ' ' + argument_line)
		case res
		when false
			STDERR.puts "WARNING: The \"#{pgname}\" executable returned non zero exit status".light_yellow
		when nil
			abort "ERROR: Cannot find or execute the \"#{pgname}\" program.\n#{File.basename(__FILE__).bold} relies on:\n - #{'dot'.bold} (from the #{'graphviz'.bold} package) to produce SVG, PDF and PNG images ;\n - #{'rsvg-convert'.bold} (from the #{'librsvg2-bin'.bold} package) to produce PDF and PGN images.\nPlease install these two package if you want to use #{File.basename(__FILE__).bold} to generate images:\n$ sudo apt-get install graphviz librsvg2-bin".light_red
		end
	end


	options = {}

	optparse = OptionParser.new do |opts|
		# Set a banner, displayed at the top
		# of the help screen.
		opts.banner = "Usage: #{File.basename($0)} -i input_blif_netlist [options]"

		opts.on('-i', '--input FILE', 'Input BLIF netlist') do |file|
			options[:input_blif] = File.expand_path(file)
		end

		opts.on('-o', '--output FILE', 'Output explicit netlist') do |file|
			options[:output_netlist] = File.expand_path(file)
		end

		opts.on('-d', '--dot [FILE]', "Output netlist as a graphviz DOT file (that can be displayed by 'xdot' or used by 'dot')") do |file|
			if file then
				options[:output_dot] = File.expand_path(file)
			else
				options[:output_dot] = false
			end
		end

		opts.on('-s', '--svg [FILE]', 'Output netlist as a SVG file') do |file|
			if file then
				options[:output_svg] = File.expand_path(file)
			else
				options[:output_svg] = false
			end
		end

		opts.on('-p', '--pdf [FILE]', 'Output netlist as a PDF file') do |file|
			if file then
				options[:output_pdf] = File.expand_path(file)
			else
				options[:output_pdf] = false
			end
		end

		opts.on('-g', '--png [FILE]', 'Output netlist as a PNG file') do |file|
			if file then
				options[:output_png] = File.expand_path(file)
			else
				options[:output_png] = false
			end
		end

		opts.on('--png-width INTEGER', 'Width (in pixels) for the output png image, exclusive with --png-height') do |i|
			options[:png_width] = i.to_i
		end

		opts.on('--png-height INTEGER', 'Height (in pixels) for the output png image, exclusive with --png-width') do |i|
			options[:png_height] = i.to_i
		end

		options[:scale] = 1.0
		opts.on('--gate-scale FLOAT', 'Logic gate size when generating images') do |f|
			options[:scale] = f.to_f
		end

		opts.on('-a', '--analyze', 'Print netlist statistics') do
			options[:analyze] = true
		end

		# This displays the help screen, all programs are
		# assumed to have this option.
		opts.on( '-h', '--help', 'Display this help' ) do
			puts opts
			puts 'Author: Théotime Bollengier <theotime.bollengier@ensta-bretagne.fr>'
			exit
		end
	end

	optparse.parse!

	STDERR.puts "WARNING: Unused commandline arguments: \"#{ARGV.join(' ')}\"".light_yellow unless ARGV.empty?
	if options[:input_blif].nil? then
		STDERR.puts "ERROR: You must specify an input file".light_red
		abort optparse.help
	end
	if options[:output_png] and options[:png_width] and options[:png_height] then
		STDERR.puts "ERROR: You must specify either the png image width or its height, but not both alltogether".light_red
		abort optparse.help
	end
		

	basename = File.join(File.dirname(File.expand_path(options[:input_blif])), File.basename(options[:input_blif], '.*'))

	if options[:output_dot] == false then
		options[:output_dot] = basename + '.dot'
	end
	if options[:output_svg] == false then
		options[:output_svg] = basename + '.svg'
	end
	if options[:output_pdf] == false then
		options[:output_pdf] = basename + '.pdf'
	end
	if options[:output_png] == false then
		options[:output_png] = basename + '.png'
	end

	if options[:scale] <= 0.0 then
		options[:scale] = 1.0
	end
	options[:scale] *= 1.5

	gn = GateNetlist.new(options[:input_blif])

	puts gn.analyze if options[:analyze]

	gn.to_explicit_netlist(options[:output_netlist]) if options[:output_netlist]

	gn.to_graph.to_graphviz(options[:output_dot]) if options[:output_dot]

	if options[:output_svg] or options[:output_pdf] or options[:output_png] then
		Dir.mktmpdir do |dir|
			Dir.chdir(dir) do
				graph = gn.to_graph
				graph.to_graphviz('netlist.dot', true)
				graph.collect_used_custom_shapes.each do |gate_name|
					File.write(gate_name + '.svg', Graph.send(('shape_' + gate_name.upcase).to_sym, options[:scale]))
				end

				execute_program('dot', '-Tsvg -o output.svg netlist.dot')

				content = File.read('output.svg')
				images = content.scan(/<image xlink:href="([^"]+)"/).flatten.collect{|s| s.sub(/\.svg$/, '')}.uniq
				top = content.match(/(.*?<svg\s.*?>)/m)[1]
				bottom = content.sub(top, '').gsub(/^\n/, '')

				str  = top + "\n"
				str += "<defs>\n"
				images.each do |imgname|
					str += "<g id=\"#{imgname}.svg\">\n"
					str += Graph.send(('shape_' + imgname.upcase).to_sym, options[:scale]).match(/<defs\s+id=".+?"\s*\/>(.*)<\/svg>/m)[1].gsub(/^\n/, '')
					str += "</g>\n"
				end
				str += "</defs>\n"
				bottom.each_line do |l|
					if match = l.match(/^<image xlink:href="([^"]+)"/) then
						l = l.sub(match[0], "<use xlink:href=\"##{match[1]}\"")
					end
					str += l
				end
				File.write('output.svg', str)

				if options[:output_svg] then
					FileUtils.cp('output.svg', options[:output_svg])
				end

				if options[:output_pdf] then
					execute_program('rsvg-convert', '-f pdf -o output.pdf output.svg')
					FileUtils.cp('output.pdf', options[:output_pdf])
				end

				if options[:output_png] then
					cmd = '-f png -o output.png'
					if options[:png_width] then
						cmd += " -a -w #{options[:png_width]}"
					elsif options[:png_height] then
						cmd += " -a -h #{options[:png_height]}"
					end
					cmd += ' output.svg'
					execute_program('rsvg-convert', cmd)
					FileUtils.cp('output.png', options[:output_png])
				end
			end
		end
	end

end

