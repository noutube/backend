package es.jakebarn.nou2ube

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.Scopes
import com.google.android.gms.common.api.Scope
import com.google.android.gms.tasks.Task

class MainActivity : AppCompatActivity() {
    private var tag = "MainActivity"
    private var rcSignIn = 1

    private lateinit var session: Session

    private lateinit var googleSignInClient: GoogleSignInClient
    private lateinit var requestQueue: RequestQueue

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        session = Session.getInstance(this)

        val googleSignInOptions = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestScopes(Scope(Scopes.EMAIL), Scope(getString(R.string.scope_youtube_readonly)))
            .requestServerAuthCode(getString(R.string.server_client_id))
            .build()
        googleSignInClient = GoogleSignIn.getClient(this, googleSignInOptions)

        requestQueue = Volley.newRequestQueue(this)
    }

    override fun onStart() {
        super.onStart()

        if (session.signedIn) {
            Log.i(tag, "was signed in as: ${session.id}, ${session.email}, ${session.authenticationToken}")
            session.signOut()
        }

        startActivityForResult(googleSignInClient.signInIntent, rcSignIn)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == rcSignIn) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            handleSignInResult(task)
        }
    }

    private fun handleSignInResult(completedTask: Task<GoogleSignInAccount>) {
        val account = completedTask.result
        val url = "${getString(R.string.server_origin)}/auth/sign_in?code=${account?.serverAuthCode}"
        val request = JsonObjectRequest(url, null,
            Response.Listener { response ->
                val data = response.getJSONObject("data")
                val attributes = data.getJSONObject("attributes")
                session.signIn(
                    data.getString("id"),
                    attributes.getString("email"),
                    attributes.getString("authentication-token")
                )
            },
            Response.ErrorListener { error ->
                Log.e(tag, "failed", error)
            }
        )
        requestQueue.add(request)
    }
}
