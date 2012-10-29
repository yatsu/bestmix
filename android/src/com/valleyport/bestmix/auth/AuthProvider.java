package com.valleyport.bestmix.auth;

import org.scribe.builder.api.DefaultApi20;
import org.scribe.extractors.AccessTokenExtractor;
import org.scribe.extractors.JsonTokenExtractor;
import org.scribe.model.OAuthConfig;
import org.scribe.utils.OAuthEncoder;
import org.scribe.utils.Preconditions;

import android.util.Log;

import com.valleyport.bestmix.common.Config;

public class AuthProvider extends DefaultApi20 {
    private static String TAG = AuthProvider.class.getName();

    private static final String AUTH_URL = Config.AUTH_BASE_URL +
            "oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s";

    @Override
    public String getAccessTokenEndpoint() {
        Log.d(TAG, "end point: " + Config.AUTH_BASE_URL +
                "oauth/token?grant_type=authorization_code");
        return Config.AUTH_BASE_URL +
                "oauth/token?grant_type=authorization_code";
    }

    @Override
    public String getAuthorizationUrl(OAuthConfig config) {
        Preconditions.checkValidUrl(config.getCallback(), "Must provide a valid url as callback.");
        return String.format(AUTH_URL, config.getApiKey(), OAuthEncoder.encode(config.getCallback()));
    }

    @Override
    public AccessTokenExtractor getAccessTokenExtractor() {
        return new JsonTokenExtractor();
    }
}
