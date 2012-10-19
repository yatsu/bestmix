package com.valleyport.bestmix.activity;

import android.app.ActionBar;
import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.app.ListFragment;
import android.os.Bundle;
import android.view.Menu;

import com.valleyport.bestmix.R;
import com.valleyport.bestmix.rest.PrivatePostsResponderFragment;
import com.valleyport.bestmix.rest.PublicPostsResponderFragment;

public class MainActivity extends Activity implements ActionBar.TabListener {

    private static final String STATE_SELECTED_NAVIGATION_ITEM = "selected_navigation_item";

    private PublicPostsFragment mPublicPostsFragment;
    private PrivatePostsFragment mPrivatePostsFragment;

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
        FragmentManager fm = getFragmentManager();
        FragmentTransaction ft = fm.beginTransaction();

        ListFragment fragment;
        if (tab.getPosition() == 0) {
            if (mPublicPostsFragment == null) {
                mPublicPostsFragment = new PublicPostsFragment();
            }
            PublicPostsResponderFragment responder =
                    (PublicPostsResponderFragment)fm.findFragmentByTag("PublicPostsResponder");
            if (responder == null) {
                responder = new PublicPostsResponderFragment();
                ft.add(responder, "PublicPostsResponder");
            }
            responder.setListener(mPublicPostsFragment);

            fragment = mPublicPostsFragment;

        } else {
            if (mPrivatePostsFragment == null) {
                mPrivatePostsFragment = new PrivatePostsFragment();
            }
            PrivatePostsResponderFragment responder =
                    (PrivatePostsResponderFragment)fm.findFragmentByTag("PrivatePostsResponder");
            if (responder == null) {
                responder = new PrivatePostsResponderFragment();
                ft.add(responder, "PrivatePostsResponder");
            }
            responder.setListener(mPrivatePostsFragment);

            fragment = mPrivatePostsFragment;
        }

        ft.replace(R.id.container, fragment).commit();
    }

    @Override
    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }
}
