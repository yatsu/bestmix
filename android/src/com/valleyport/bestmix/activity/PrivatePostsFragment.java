package com.valleyport.bestmix.activity;

import java.util.List;

import android.app.ListFragment;
import android.os.Bundle;
import android.util.Log;
import android.widget.ArrayAdapter;

import com.valleyport.bestmix.R;
import com.valleyport.bestmix.model.Post;
import com.valleyport.bestmix.rest.PostsResponderFragment.PostsResponderListener;

public class PrivatePostsFragment extends ListFragment implements PostsResponderListener {
    private static String TAG = PublicPostsFragment.class.getName();

    private ArrayAdapter<String> mPostsAdapter;

    private List<Post> mPosts;

    public PrivatePostsFragment() {
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        if (mPosts != null) {
            setPostsAdapter();
        }
    }

    @Override
    public void onSuccess(List<Post> posts) {
        Log.d(TAG, "onSuccess - activity: " + getActivity());

        mPosts = posts;
        if (getActivity() != null) {
            setPostsAdapter();
            setListShown(true);
        }
    }

    @Override
    public void onFailure(int code, String response) {
        Log.d(TAG, "onFailure - code: " + code + " response: " + response);
        //Toast.makeText(getActivity(), "Failed to load data. Check your internet settings.", Toast.LENGTH_SHORT).show();
        //setListShown(true);

        mPosts = null;

        if (getActivity() != null) {
            if (code == 401) {
                setEmptyText("Login Required");
            } else {
                setEmptyText(response);
            }

            setPostsAdapter();
            setListShown(true);
        }
    }

    private void setPostsAdapter() {
        if (mPostsAdapter == null) {
            mPostsAdapter = new ArrayAdapter<String>(getActivity(), R.layout.post);
            setListAdapter(mPostsAdapter);
        }

        // Load our list adapter with our posts.
        mPostsAdapter.clear();
        if (mPosts != null) {
            for (Post post : mPosts) {
                mPostsAdapter.add(post.getTitle());
            }
        }
    }
}
