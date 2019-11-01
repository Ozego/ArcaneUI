using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIDistanceConstraint : MonoBehaviour
{
    [SerializeField] Transform  anchor;
    [SerializeField] float      radius;
    Vector3 oldPosition;
    Vector3 d = new Vector3(0f,0f,0f);
    void Update()
    {
        d += transform.position-oldPosition;
        d -= new Vector3(0f,4f,0f);
        float distance = Vector2.Distance(transform.position, anchor.position);
        if(distance>radius)
        {
            transform.position = circleProject(transform.position, anchor.position, radius);
        }
        oldPosition = transform.position;
    }

    private Vector3 circleProject(Vector3 point, Vector3 anchor, float radius)
    {
        return (Vector3.Normalize(point - anchor) * radius) + anchor;
    }
}
