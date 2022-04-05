package com.dexterous.flutterlocalnotifications.models;

import androidx.annotation.Keep;
import java.io.Serializable;

@Keep
public class PayLoad implements Serializable {
    public String data;
    public String appState;

    public PayLoad(String data, String appState) {
        this.data = data;
        this.appState= appState;
    }
}
