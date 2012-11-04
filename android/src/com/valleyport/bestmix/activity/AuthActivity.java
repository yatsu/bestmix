package com.valleyport.bestmix.activity;

import org.scribe.model.Token;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.valleyport.bestmix.R;
import com.valleyport.bestmix.auth.AuthManager;
import com.valleyport.bestmix.common.Config;

public class AuthActivity extends Activity {
    private static String TAG = AuthActivity.class.getName();

    private OAuthService service;

    AuthActivity activity = this;

    Toast toast;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.webview);

        WebView webView = (WebView)findViewById(R.id.webview);

        service = AuthManager.getInstance().getAuthService();

        // attach WebViewClient to intercept the callback url
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // check for our custom callback protocol otherwise use default behavior
                if (url.startsWith(Config.REDIRECT_URL)) {
                    // authorization complete hide webview for now.
                    view.setVisibility(View.GONE);

                    toast = Toast.makeText(activity, "Authorizing...", Toast.LENGTH_SHORT);
                    toast.show();


                    Uri uri = Uri.parse(url);
                    String code = uri.getQueryParameter("code");
                    new AuthAsyncTask(activity).execute(code);

                    return true;
                }

                return super.shouldOverrideUrlLoading(view, url);
            }
        });

        webView.loadUrl(service.getAuthorizationUrl(null));
    }

    public void onFinish(Token token) {
        //Log.d(TAG, "token: " + token.getToken());
        if (toast != null) {
            toast.cancel();
            toast = null;
        }
        AuthManager.getInstance().setToken(activity, token.getToken());

        Intent intent = new Intent();
        intent.putExtra("authenticated", true);
        setResult(Activity.RESULT_OK, intent);
        finish();
    }

    private class AuthAsyncTask extends AsyncTask<String, Integer, Void> {
        private final AuthActivity mActivity;

        public AuthAsyncTask(AuthActivity activity) {
            mActivity = activity;
        }

        @Override
        protected Void doInBackground(String... params) {
            String code = params[0];
            //Log.d(TAG, "code: " + code);
            Verifier verifier = new Verifier(code);
            Token token = service.getAccessToken(null, verifier);
            mActivity.onFinish(token);

            return null;
        }
    }
}
