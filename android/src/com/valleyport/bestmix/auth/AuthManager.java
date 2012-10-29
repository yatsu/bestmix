package com.valleyport.bestmix.auth;

import org.scribe.builder.ServiceBuilder;
import org.scribe.oauth.OAuthService;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

import com.valleyport.bestmix.common.Config;

public class AuthManager {
    //private static String TAG = AuthManager.class.getName();

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

    public void clearToken(Context context) {
        setToken(context, null);
    }

    public OAuthService getAuthService() {
        return new ServiceBuilder()
        .provider(AuthProvider.class)
        .apiKey(Config.CLIENT_ID)
        .apiSecret(Config.CLIENT_SECRET)
        .callback(Config.REDIRECT_URL)
        .build();
    }
}
