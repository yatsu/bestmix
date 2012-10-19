package com.valleyport.bestmix.auth;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

public class AuthManager {
    private static AuthManager instance = new AuthManager();

    private AuthManager() {}

    static public AuthManager getInstance() {
        return instance;
    }

    private SharedPreferences getPrefs(Context context) {
        return PreferenceManager.getDefaultSharedPreferences(context);
    }

    public boolean isLoggedIn(Context context) {
        return getToken(context) != null;
    }

    public String getToken(Context context) {
        return getPrefs(context).getString("token", null);
    }

    public void setToken(Context context, String token) {
        SharedPreferences prefs = getPrefs(context);
        Editor editor = prefs.edit();
        if (token == null) {
            editor.remove("token");
        } else {
            editor.putString("token", token);
        }
        editor.commit();
    }
}
