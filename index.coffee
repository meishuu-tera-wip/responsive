module.exports = class Responsive
	constructor: (dispatch) ->
		party = {}
		players = {}

		dispatch.hook 'sPartyList', (event) ->
			party = {}
			players = {}

			for {cID, pID} in event.members
				party[pID.high] ?= {}
				party[pID.high][pID.low] = cID

				players[cID.high] ?= {}
				players[cID.high][cID.low] =
					pID: pID
					loc3: 0

			return

		dispatch.hook 'sPartyMove', (event) ->
			target = event.target
			cID = party[target.high]?[target.low]
			if cID?
				players[cID.high][cID.low].loc3 = event.location3
			return

		dispatch.hook 'sPlayerMove', (event) ->
			target = event.target
			p = players[target.high]?[target.low]
			if p? and p.loc3
				dispatch.toClient 'sPartyMove',
					target: p.pID
					x: event.x1
					y: event.y1
					z: event.z1
					location3: p.loc3
					unk: 1
			return
