# autoloads/APIManager..gd
extends Node

const _PASS = "AlgomateEncryptedPasswordSkibidi"

const KEY_A_CLIENTID =     [114, 15, 86, 94, 12, 86, 23, 93, 112, 92, 86, 70, 28, 66, 18, 84, 81, 100, 4, 18, 74, 20, 93, 16, 6, 53, 88, 13, 83, 90, 81, 95]
const KEY_A_CLIENTSECRET = [120, 93, 95, 10, 88, 88, 67, 1, 124, 87, 5, 71, 76, 20, 23, 85, 93, 103, 83, 22, 74, 69, 86, 69, 85, 98, 83, 80, 7, 13, 83, 95, 37, 88, 80, 9, 94, 0, 76, 81, 112, 90, 82, 68, 78, 72, 21, 83, 84, 54, 87, 70, 18, 78, 88, 74, 83, 97, 83, 80, 81, 93, 7, 10]
const KEY_B_CLIENTID =     [115, 85, 4, 13, 89, 85, 71, 6, 39, 86, 83, 69, 27, 19, 23, 3, 92, 105, 84, 75, 69, 64, 86, 20, 5, 103, 91, 89, 84, 94, 0, 10]
const KEY_B_CLIENTSECRET = [32, 15, 83, 13, 84, 88, 21, 83, 116, 94, 81, 16, 65, 18, 64, 82, 86, 53, 89, 23, 18, 65, 88, 66, 83, 106, 83, 80, 86, 88, 0, 13, 35, 14, 3, 91, 90, 80, 64, 93, 32, 87, 84, 19, 76, 69, 64, 0, 7, 51, 2, 22, 66, 71, 95, 64, 80, 101, 8, 10, 0, 88, 5, 13]
const KEY_C_CLIENTID =     [32, 15, 2, 12, 95, 85, 22, 6, 35, 86, 80, 67, 79, 71, 18, 84, 81, 105, 89, 70, 75, 69, 90, 69, 81, 107, 92, 8, 80, 92, 0, 95]
const KEY_C_CLIENTSECRET = [115, 95, 6, 87, 90, 0, 22, 84, 116, 12, 5, 66, 26, 65, 18, 6, 81, 102, 88, 64, 67, 67, 91, 19, 84, 49, 92, 13, 83, 90, 86, 95, 121, 85, 86, 94, 11, 80, 69, 86, 118, 94, 2, 74, 26, 66, 68, 83, 83, 104, 89, 23, 74, 67, 12, 68, 82, 106, 88, 90, 86, 15, 7, 91]
const KEY_D_CLIENTID =     [39, 88, 1, 12, 85, 84, 67, 80, 32, 11, 85, 17, 77, 69, 23, 4, 85, 50, 0, 21, 69, 78, 88, 19, 86, 107, 9, 80, 85, 94, 85, 12]
const KEY_D_CLIENTSECRET = [118, 8, 95, 13, 93, 87, 68, 81, 112, 87, 5, 16, 74, 64, 64, 86, 81, 98, 7, 65, 71, 68, 13, 64, 5, 106, 94, 88, 91, 93, 7, 89, 117, 14, 1, 94, 93, 84, 68, 86, 39, 95, 2, 66, 79, 65, 70, 83, 84, 100, 82, 17, 16, 67, 9, 65, 7, 50, 15, 8, 81, 95, 82, 12]

# -------------------------------------------------------
# Internal decode function
# -------------------------------------------------------
func _decode(encoded: Array) -> String:
	var result = ""
	for i in encoded.size():
		result += char(encoded[i] ^ ord(_PASS[i % _PASS.length()]))
	return result

# -------------------------------------------------------
# Public API — call this from any simulation script
# Usage: APIManager.get_keys("KEY_A")  → {"clientId": "...", "clientSecret": "..."}
# -------------------------------------------------------
func get_keys(key_name: String) -> Dictionary:
	match key_name:
		"KEY_A":
			return {
				"clientId": _decode(KEY_A_CLIENTID),
				"clientSecret": _decode(KEY_A_CLIENTSECRET)
			}
		"KEY_B":
			return {
				"clientId": _decode(KEY_B_CLIENTID),
				"clientSecret": _decode(KEY_B_CLIENTSECRET)
			}
		"KEY_C":
			return {
				"clientId": _decode(KEY_C_CLIENTID),
				"clientSecret": _decode(KEY_C_CLIENTSECRET)
			}
		"KEY_D":
			return {
				"clientId": _decode(KEY_D_CLIENTID),
				"clientSecret": _decode(KEY_D_CLIENTSECRET)
			}
	push_error("APIManager: unknown key name: " + key_name)
	return {}
