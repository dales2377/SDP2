package com.example.event;

import org.springframework.context.ApplicationEvent;

public class OrderChangeEvent extends ApplicationEvent {
    public OrderChangeEvent(Object source) {
        super(source);
    }
}
