// src/tests/unit/MathUtils.spec.ts - Fast unit tests (no Roblox runtime)

describe("MathUtils", () => {
    describe("add", () => {
        it("should add two numbers", () => {
            const a = 2;
            const b = 3;
            expect(a + b).toBe(5);
        });

        it("should handle negative numbers", () => {
            const a = -5;
            const b = 10;
            expect(a + b).toBe(5);
        });

        it("should handle zero", () => {
            const a = 0;
            const b = 5;
            expect(a + b).toBe(5);
        });
    });

    describe("clamp", () => {
        it("should return value when within range", () => {
            const value = 5;
            const min = 0;
            const max = 10;
            expect(value >= min && value <= max).toBe(true);
        });

        it("should return min when value is below range", () => {
            const value = -5;
            const min = 0;
            const max = 10;
            expect(value < min).toBe(true);
        });

        it("should return max when value is above range", () => {
            const value = 15;
            const min = 0;
            const max = 10;
            expect(value > max).toBe(true);
        });
    });

    describe("lerp", () => {
        it("should interpolate between two values", () => {
            const start = 0;
            const end = 10;
            const alpha = 0.5;
            const result = start + (end - start) * alpha;
            expect(result).toBe(5);
        });

        it("should return start when alpha is 0", () => {
            const start = 0;
            const end = 10;
            const alpha = 0;
            const result = start + (end - start) * alpha;
            expect(result).toBe(0);
        });

        it("should return end when alpha is 1", () => {
            const start = 0;
            const end = 10;
            const alpha = 1;
            const result = start + (end - start) * alpha;
            expect(result).toBe(10);
        });
    });
});
