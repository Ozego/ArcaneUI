using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIDistanceConstraint : MonoBehaviour
{
    [SerializeField] Transform  anchor;
    [SerializeField] float      radius;
    [SerializeField] float      inertia;
    [SerializeField] float      gravity;
    Vector3 oldPosition;

    void Awake()
    {
        oldPosition = transform.position;
    }
    void Update()
    {
        Vector3 d = transform.position-oldPosition;
        d *= inertia;
        d += Vector3.down*gravity*Time.deltaTime;
        oldPosition = transform.position;
        transform.position += d;
        float distance = Vector3.Distance(transform.position, anchor.position);
        if(distance>radius)
        {
            transform.position = circleProject(transform.position, anchor.position, radius);
        }
    }

    private Vector3 circleProject(Vector3 point, Vector3 anchor, float radius)
    {
        return (Vector3.Normalize(point - anchor) * radius) + anchor;
    }
}
