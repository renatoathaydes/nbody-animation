/* The Computer Language Benchmarks Game
 
   http://benchmarksgame.alioth.debian.org/
 
  
   contributed by Renato Athaydes
 
 */
Float pi = 3.14159265358979323846264338327;
Float solarMass = 4 * pi * pi;
Float daysPerYear = 365.24;
Float sqrt(Float f) => f^0.5;

shared abstract class Body(shared variable Float x, shared variable Float y, shared variable Float z,
    shared variable Float vx, shared variable Float vy, shared variable Float vz,
    shared Float mass) of sun|jupiter|saturn|uranus|neptune {
    
    shared Body offsetMomentum(Float px, Float py, Float pz) {
        vx = -px / solarMass;
        vy = -py / solarMass;
        vz = -pz / solarMass;
        return this;
    }
}

object jupiter extends Body(4.84143144246472090e+00,
    -1.16032004402742839e+00,
    -1.03622044471123109e-01,
    1.66007664274403694e-03 * daysPerYear,
    7.69901118419740425e-03 * daysPerYear,
    -6.90460016972063023e-05 * daysPerYear,
    9.54791938424326609e-04 * solarMass) {}

object saturn extends Body(8.34336671824457987e+00,
    4.12479856412430479e+00,
    -4.03523417114321381e-01,
    -2.76742510726862411e-03 * daysPerYear,
    4.99852801234917238e-03 * daysPerYear,
    2.30417297573763929e-05 * daysPerYear,
    2.85885980666130812e-04 * solarMass) {}

object uranus extends Body(1.28943695621391310e+01,
    -1.51111514016986312e+01,
    -2.23307578892655734e-01,
    2.96460137564761618e-03 * daysPerYear,
    2.37847173959480950e-03 * daysPerYear,
    -2.96589568540237556e-05 * daysPerYear,
    4.36624404335156298e-05 * solarMass) {}

object neptune extends Body(1.53796971148509165e+01,
    -2.59193146099879641e+01,
    1.79258772950371181e-01,
    2.68067772490389322e-03 * daysPerYear,
    1.62824170038242295e-03 * daysPerYear,
    -9.51592254519715870e-05 * daysPerYear,
    5.15138902046611451e-05 * solarMass) {}

object sun extends Body(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, solarMass) {}

shared class NBodySystem() {
    
    shared [Body+] bodies = [sun, jupiter, saturn, uranus, neptune];
    
    variable value px = 0.0;
    variable value py = 0.0;
    variable value pz = 0.0;
    
    value iter = bodies.iterator();
    while (!is Finished next = iter.next()) {
        px += next.vx*next.mass;
        py += next.vy*next.mass;
        pz += next.vz*next.mass;
    }
    
    bodies.first.offsetMomentum(px, py, pz);
    
    shared void advance(Float dt) {
        
        value iter = bodies.iterator();
        variable Body[] remaining = bodies.rest;
        while (!is Finished iBody = iter.next()) {
            value iter2 = remaining.iterator();
            while (!is Finished other = iter2.next()) {
                value dx = iBody.x - other.x;
                value dy = iBody.y - other.y;
                value dz = iBody.z - other.z;
                
                value dSquared = dx*dx + dy*dy + dz*dz;
                value distance = sqrt(dSquared);
                value mag = dt / (dSquared * distance);
                
                iBody.vx -= dx*other.mass*mag;
                iBody.vy -= dy*other.mass*mag;
                iBody.vz -= dz*other.mass*mag;
                
                other.vx += dx*iBody.mass*mag;
                other.vy += dy*iBody.mass*mag;
                other.vz += dz*iBody.mass*mag;
            }
            remaining = remaining.rest;
        }
        
        for (body in bodies) {
            body.x += dt*body.vx;
            body.y += dt*body.vy;
            body.z += dt*body.vz;
        }
    }
    
    shared Float energy() {
        variable Float e = 0.0;
        
        value iter = bodies.iterator();
        variable Body[] remaining = bodies.rest;
        while (!is Finished iBody = iter.next()) {
            value iter2 = remaining.iterator();
            e += 0.5*iBody.mass *
                    (iBody.vx*iBody.vx
                + iBody.vy*iBody.vy
                    + iBody.vz*iBody.vz);
            
            while (!is Finished other = iter2.next()) {
                value dx = iBody.x - other.x;
                value dy = iBody.y - other.y;
                value dz = iBody.z - other.z;
                
                value distance = sqrt(dx*dx + dy*dy + dz*dz);
                e -= (iBody.mass * other.mass) / distance;
            }
            remaining = remaining.rest;
        }
        return e;
    }
    
}
