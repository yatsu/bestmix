package com.valleyport.bestmix.rest;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;
import com.valleyport.bestmix.activity.MainActivity;
import com.valleyport.bestmix.common.Config;
import com.valleyport.bestmix.model.Post;

public abstract class PostsResponderFragment extends RESTResponderFragment {

    public interface PostsResponderListener {
        public void onSuccess(List<Post> posts);
        public void onFailure(int code, String response);
    }

    private static String TAG = PostsResponderFragment.class.getName();

    protected String path = "";

    // We cache our stored posts here so that we can return right away
    // on multiple calls to setPosts() during the Activity lifecycle events (such
    // as when the user rotates their device). In a real application we would want
    // to cache this data in a more sophisticated way, probably using SQLite and
    // Content Providers, but for the demo and simple apps this will do.
    protected List<Post> mPosts;

    protected int mCurrentPage;
    protected int mTotalCount;
    protected int mNumPages;

    protected PostsResponderListener mListener;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        mCurrentPage = 0;
        mTotalCount = 0;
        mNumPages = 0;

        // This gets called each time our Activity has finished creating itself.
        setPosts();
    }

    public void setListener(PostsResponderListener listener) {
        mListener = listener;
    }

    public void reload() {
        clearPosts();
        setPosts();
    }

    protected void setPosts() {
        Log.d(TAG, "setPosts");
        MainActivity activity = (MainActivity)getActivity();

        if (mPosts == null && activity != null) {
            // This is where we make our REST call to the service. We also pass in our ResultReceiver
            // defined in the RESTResponderFragment super class.

            // We will explicitly call our Service since we probably want to keep it as a private
            // component in our app. You could do this with Intent actions as well, but you have
            // to make sure you define your intent filters correctly in your manifest.
            Intent intent = new Intent(activity, RESTService.class);
            intent.setData(Uri.parse(Config.WEB_API_URL + path));

            intent.putExtra(RESTService.EXTRA_RESULT_RECEIVER, getResultReceiver());

            // Here we send our Intent to our RESTService.
            Log.d(TAG, "start service");
            activity.startService(intent);
        }
        else if (mPosts != null && activity != null) {
            // Here we check to see if our activity is null or not.
            // We only want to update our views if our activity exists.
            if (mListener != null) {
                mListener.onSuccess(mPosts);
            }
        }
    }

    public List<Post> getPosts() {
        return mPosts;
    }

    public void clearPosts() {
        mPosts = null;
    }

    @Override
    public void onRESTResult(int code, String result) {
        Log.d(TAG, "result: " + result);
        // Here is where we handle our REST response. This is similar to the
        // LoaderCallbacks<D>.onLoadFinished() call from the previous tutorial.

        // Check to see if we got an HTTP 200 code and have some data.
        if (code == 200 && result != null) {
            try {
                JSONObject json = (JSONObject)new JSONTokener(result).nextValue();
                mCurrentPage = json.getInt("current_page");
                mTotalCount = json.getInt("total_count");
                mNumPages = json.getInt("num_pages");
                Log.d(TAG, "current_page: " + mCurrentPage + " total_count: " + mTotalCount + " num_pages: " + mNumPages);
                mPosts = getPostsFromJson(json);
            }
            catch (JSONException e) {
                Log.e(TAG, "Failed to parse JSON.", e);
                if (mListener != null) {
                    mListener.onFailure(code, result);
                }
            }
            setPosts();
        }
        else {
            if (mListener != null) {
                mListener.onFailure(code, result);
            }
        }
    }

    protected static List<Post> getPostsFromJson(JSONObject json) throws JSONException {
        Gson gson = new Gson();
        ArrayList<Post> postList = new ArrayList<Post>();
        JSONArray postArray = json.getJSONArray("posts");
        for (int i = 0; i < postArray.length(); i++) {
            String post = postArray.getJSONObject(i).getString("post");
            //Log.d(TAG,  "post: " + post);
            postList.add(gson.fromJson(post, Post.class));
        }
        return postList;
    }
}
