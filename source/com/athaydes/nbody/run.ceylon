NBodySystem bodiesSystem = NBodySystem();

shared void run() {
    dynamic {
        dynamic canvas = document.getElementById("screen");
        dynamic context = canvas.getContext("2d");
        dynamic offsetX = canvas.width / 2;
        dynamic offsetY = canvas.height / 2;
        void tick() {
            context.clearRect(0, 0, canvas.width, canvas.height);
            for (body in bodiesSystem.bodies) {
                draw(context, body, offsetX, offsetY);                
            }
            updateBodies();
            requestAnimationFrame(tick);
        }
        tick();
    }
}

shared void draw(dynamic context, Body body, dynamic offsetX, dynamic offsetY) {
    dynamic {
        context.fillRect(body.x + offsetX, body.y + offsetY, 5, 5);
    }
}

shared void updateBodies() => bodiesSystem.advance(0.05);
