package com.scms

import org.apache.commons.lang.builder.HashCodeBuilder

class SecUserSecRole implements Serializable {

	private static final long serialVersionUID = 1

	SecUser secUser
	SecRole secRole
	long appsId

	boolean equals(other) {
		if (!(other instanceof SecUserSecRole)) {
			return false
		}

		other.secUser?.id == secUser?.id &&
				other.secRole?.id == secRole?.id
	}

	int hashCode() {
		def builder = new HashCodeBuilder()
		if (secUser) builder.append(secUser.id)
		if (secRole) builder.append(secRole.id)
		builder.toHashCode()
	}

	static SecUserSecRole get(long secUserId, long secRoleId) {
		SecUserSecRole.where {
			secUser == SecUser.load(secUserId) &&
					secRole == SecRole.load(secRoleId) && appsId ==3L
		}.get()
	}

	static boolean exists(long secUserId, long secRoleId) {
		SecUserSecRole.where {
			secUser == SecUser.load(secUserId) &&
					secRole == SecRole.load(secRoleId) && appsId ==3L
		}.count() > 0
	}

	static SecUserSecRole create(SecUser secUser, SecRole secRole, boolean flush = false) {
		def instance = new SecUserSecRole(secUser: secUser, secRole: secRole, appsId: 3L)
		instance.save(flush: flush, insert: true)
		instance
	}

	static boolean remove(SecUser u, SecRole r, boolean flush = false) {
		if (u == null || r == null) return false

		int rowCount = SecUserSecRole.where {
			secUser == SecUser.load(u.id) &&
					secRole == SecRole.load(r.id) && appsId ==3L
		}.deleteAll()

		if (flush) { SecUserSecRole.withSession { it.flush() } }

		rowCount > 0
	}

	static void removeAll(SecUser u, boolean flush = false) {
		if (u == null) return

		SecUserSecRole.where {
			secUser == SecUser.load(u.id) && appsId ==3L
		}.deleteAll()

		if (flush) { SecUserSecRole.withSession { it.flush() } }
	}

	static void removeAll(SecRole r, boolean flush = false) {
		if (r == null) return

		SecUserSecRole.where {
			secRole == SecRole.load(r.id) && appsId ==3L
		}.deleteAll()

		if (flush) { SecUserSecRole.withSession { it.flush() } }
	}

	static constraints = {
		appsId nullable: true
		secRole validator: { SecRole r, SecUserSecRole ur ->
			if (ur.secUser == null) return
			boolean existing = false
			SecUserSecRole.withNewSession {
				existing = SecUserSecRole.exists(ur.secUser.id, r.id)
			}
			if (existing) {
				return 'userRole.exists'
			}
		}
	}

	static mapping = {
		datasource 'comn'
		id composite: ['secRole', 'secUser']
		version false
	}
}
