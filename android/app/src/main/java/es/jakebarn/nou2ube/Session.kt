package es.jakebarn.nou2ube

import android.content.Context
import android.util.Log

class Session private constructor(context: Context) {
    companion object : SingletonHolder<Session, Context> (::Session)

    private val tag = "Session"

    private val preferenceName = context.getString(R.string.session_preference_name)
    private val idKey = context.getString(R.string.session_id_key)
    private val emailKey = context.getString(R.string.session_email_key)
    private val authenticationTokenKey = context.getString(R.string.session_authentication_token_key)

    private val sharedPreferences = context.getSharedPreferences(preferenceName, Context.MODE_PRIVATE)
    private val editor = sharedPreferences.edit()

    fun signIn(id: String, email: String, authenticationToken: String) {
        editor.putString(idKey, id)
        editor.putString(emailKey, email)
        editor.putString(authenticationTokenKey, authenticationToken)
        editor.apply()

        Log.i(tag, "signed in: ${this.id}, ${this.email}, ${this.authenticationToken}")
    }

    fun signOut() {
        editor.clear()
        editor.apply()

        Log.i(tag, "signed out")
    }

    val id: String? get() = sharedPreferences.getString(idKey, null)
    val email: String? get() = sharedPreferences.getString(emailKey, null)
    val authenticationToken: String? get() = sharedPreferences.getString(authenticationTokenKey, null)

    val signedIn get() = id != null
}