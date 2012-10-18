package com.valleyport.bestmix.rest;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Toast;

import com.valleyport.bestmix.activity.MainActivity;

public class PostsResponderFragment extends RESTResponderFragment {
    private static String TAG = PostsResponderFragment.class.getName();

    // We cache our stored posts here so that we can return right away
    // on multiple calls to setPosts() during the Activity lifecycle events (such
    // as when the user rotates their device). In a real application we would want
    // to cache this data in a more sophisticated way, probably using SQLite and
    // Content Providers, but for the demo and simple apps this will do.
    private List<String> mPosts;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        // This gets called each time our Activity has finished creating itself.
        setPosts();
    }

    private void setPosts() {
        MainActivity activity = (MainActivity)getActivity();

        if (mPosts == null && activity != null) {
            // This is where we make our REST call to the service. We also pass in our ResultReceiver
            // defined in the RESTResponderFragment super class.

            // We will explicitly call our Service since we probably want to keep it as a private
            // component in our app. You could do this with Intent actions as well, but you have
            // to make sure you define your intent filters correctly in your manifest.
            Intent intent = new Intent(activity, RESTService.class);
            intent.setData(Uri.parse("http://search.twitter.com/search.json"));

            // Here we are going to place our REST call parameters. Note that
            // we could have just used Uri.Builder and appendQueryParameter()
            // here, but I wanted to illustrate how to use the Bundle params.
            Bundle params = new Bundle();
            params.putString("q", "android");

            intent.putExtra(RESTService.EXTRA_PARAMS, params);
            intent.putExtra(RESTService.EXTRA_RESULT_RECEIVER, getResultReceiver());

            // Here we send our Intent to our RESTService.
            activity.startService(intent);
        }
        else if (activity != null) {
            // Here we check to see if our activity is null or not.
            // We only want to update our views if our activity exists.

            ArrayAdapter<String> adapter = activity.getPostsAdapter();

            // Load our list adapter with our posts.
            adapter.clear();
            for (String post : mPosts) {
                adapter.add(post);
            }
        }
    }

    @Override
    public void onRESTResult(int code, String result) {
        Log.d("Bestmix",  "onRESTResult");
        // Here is where we handle our REST response. This is similar to the
        // LoaderCallbacks<D>.onLoadFinished() call from the previous tutorial.

        // Check to see if we got an HTTP 200 code and have some data.
        if (code == 200 && result != null) {
            mPosts = getPostsFromJson(result);
            setPosts();
        }
        else {
            Activity activity = getActivity();
            if (activity != null) {
                Toast.makeText(activity, "Failed to load Twitter data. Check your internet settings.", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private static List<String> getPostsFromJson(String json) {
        ArrayList<String> postList = new ArrayList<String>();

        try {
            JSONObject postsWrapper = (JSONObject) new JSONTokener(json).nextValue();
            JSONArray  posts        = postsWrapper.getJSONArray("results");

            for (int i = 0; i < posts.length(); i++) {
                JSONObject post = posts.getJSONObject(i);
                postList.add(post.getString("text"));
            }
        }
        catch (JSONException e) {
            Log.e(TAG, "Failed to parse JSON.", e);
        }

        return postList;
    }

}
