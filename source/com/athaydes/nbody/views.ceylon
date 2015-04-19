shared class BodyProperties(
    shared String color
) {}

object sunProperties {
    
    shared BodyProperties get = BodyProperties {
        color = "yellow";
    };
    
}

object jupiterProperties {
    
    shared BodyProperties get = BodyProperties {
        color = "brown";
    };
    
}

object saturnProperties {
    
    shared BodyProperties get = BodyProperties {
        color = "gray";
    };
    
}

object uranusProperties {
    
    shared BodyProperties get = BodyProperties {
        color = "blue";
    };
    
}

object neptuneProperties {
    
    shared BodyProperties get = BodyProperties {
        color = "darkblue";
    };
    
}

shared BodyProperties propertiesOf(Body body) {
    switch (body)
    case (sun) { return sunProperties.get; }
    case (jupiter) { return jupiterProperties.get; }
    case (saturn) { return saturnProperties.get; }
    case (uranus) { return uranusProperties.get; }
    case (neptune) { return neptuneProperties.get; }
}

shared class BodyDrawer(CanvasRenderingContext2D context, Float offsetX, Float offsetY) {
    
     value scale = 4.0;
    
    shared void draw(Body body) {
        value properties = propertiesOf(body);
        dynamic {
            context.fillStyle = properties.color;
            context.beginPath();
            context.arc((body.x * scale) + offsetX, (body.y * scale) + offsetY, 5.0, 0.0, 2*pi);
            context.fill();
        }
    }
    
}
