let utils = Group("Utils") {
	RequestDef("utils.getServerTime", resultType: .unixTimestamp) {
	}
	.doc("Returns the server's current time.")
}
