NBodySystem bodiesSystem = NBodySystem();

shared void run() {
    dynamic {
        dynamic canvas = document.getElementById("screen");
        dynamic context = canvas.getContext("2d");
        dynamic offsetX = canvas.width / 2;
        dynamic offsetY = canvas.height / 2;
        value bodyDrawer = BodyDrawer(context, offsetX, offsetY);
        void tick() {
            context.clearRect(0, 0, canvas.width, canvas.height);
            for (body in bodiesSystem.bodies) {
                bodyDrawer.draw(body);                
            }
            updateBodies();
            requestAnimationFrame(tick);
        }
        tick();
    }
}

shared void updateBodies() => bodiesSystem.advance(0.05);
