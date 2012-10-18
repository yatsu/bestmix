package com.valleyport.bestmix.model;

import com.google.gson.annotations.SerializedName;

public class Post {
    @SerializedName("id") private int postId;
    private String title;
    private String content;

    public int getPostId() {
        return postId;

    }
    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
