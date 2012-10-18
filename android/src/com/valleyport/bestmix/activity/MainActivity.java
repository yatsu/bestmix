package com.valleyport.bestmix.activity;

import android.app.ActionBar;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.app.ListFragment;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.Menu;
import android.widget.ArrayAdapter;

import com.valleyport.bestmix.R;
import com.valleyport.bestmix.rest.PostsResponderFragment;

public class MainActivity extends FragmentActivity implements ActionBar.TabListener {

    private static final String STATE_SELECTED_NAVIGATION_ITEM = "selected_navigation_item";

    private ArrayAdapter<String> mPostsAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Set up the action bar.
        final ActionBar actionBar = getActionBar();
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

        // For each of the sections in the app, add a tab to the action bar.
        actionBar.addTab(actionBar.newTab().setText(R.string.title_posts).setTabListener(this));
        actionBar.addTab(actionBar.newTab().setText(R.string.title_my_posts).setTabListener(this));
    }

    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
        if (savedInstanceState.containsKey(STATE_SELECTED_NAVIGATION_ITEM)) {
            getActionBar().setSelectedNavigationItem(
                    savedInstanceState.getInt(STATE_SELECTED_NAVIGATION_ITEM));
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        outState.putInt(STATE_SELECTED_NAVIGATION_ITEM,
                getActionBar().getSelectedNavigationIndex());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return true;
    }

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    @Override
    public void onTabSelected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
        Log.d("Bestmix",  "onTabSelected");
        FragmentManager fm = getFragmentManager();
        FragmentTransaction ft = fm.beginTransaction();

        ListFragment fragment;
        if (tab.getPosition() == 0) {
            fragment = new PublicPostsFragment();
            if (mPostsAdapter == null) {
                mPostsAdapter = new ArrayAdapter<String>(this, R.layout.post);
            }
            fragment.setListAdapter(mPostsAdapter);

            PostsResponderFragment responder = (PostsResponderFragment)fm.findFragmentByTag("PostsResponder");
            if (responder == null) {
                responder = new PostsResponderFragment();
                // We add the fragment using a Tag since it has no views. It will make the Twitter REST call
                // for us each time this Activity is created.
                ft.add(responder, "PostsResponder");
            }

        } else {
            fragment = new PrivatePostsFragment();
        }

        ft.replace(R.id.container, fragment).commit();
    }

    @Override
    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    public ArrayAdapter<String> getPostsAdapter() {
        return mPostsAdapter;
    }
}
