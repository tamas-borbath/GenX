"""
GenX: An Configurable Capacity Expansion Model
Copyright (C) 2021,  Massachusetts Institute of Technology
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
A complete copy of the GNU General Public License v2 (GPLv2) is available
in LICENSE.txt.  Users uncompressing this from an archive may not have
received this license file.  If not, see <http://www.gnu.org/licenses/>.
"""

function write_opwrap_lds_stor_init(path::AbstractString, sep::AbstractString, inputs::Dict, setup::Dict, EP::Model)
	## Extract data frames from input dictionary
	dfGen = inputs["dfGen"]
	G = inputs["G"]

	# Initial level of storage in each modeled period
	NPeriods = size(inputs["Period_Map"])[1]
	dfStorageInit = DataFrame(Resource = inputs["RESOURCES"], Zone = dfGen[!,:Zone])
	socw = zeros(G,NPeriods)
	for i in 1:G
		if i in inputs["STOR_ALL"]
			socw[i,:] = value.(EP[:vSOCw])[i,:]
		end
	end
	dfStorageInit = hcat(dfStorageInit, convert_to_DataFrame(socw))
	auxNew_Names=[Symbol("Resource");Symbol("Zone");[Symbol("n$t") for t in 1:NPeriods]]
	rename!(dfStorageInit,auxNew_Names)
	CSV.write(string(path,sep,"StorageInit.csv"), dftranspose(dfStorageInit, false), writeheader=false)
end
