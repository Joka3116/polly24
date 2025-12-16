<template>
    <nav>
        <div id="nav-overlay" :class="{ active: isMenuOpen }">
            <div id="nav-overlay-container">
                <ul>
                    <li>
                        <slot></slot>
                    </li>
                </ul>
            </div>
        </div>
        <div id="hamburger" :class="{ active: isMenuOpen }" @click="toggleMenu">
            <span id="hamburger-line-one"></span>
            <span id="hamburger-line-two"></span>
        </div>
    </nav>
</template>

<script>
export default {
    name: "ResponsiveNav",
    data() {
        return {
            isMenuOpen: false,
        };
    },
    methods: {
        toggleMenu() {
            this.isMenuOpen = !this.isMenuOpen;
        },
    },
};
</script>

<style scoped>
nav {
    position: relative;
    top: 0;
    left: 0;
    width: auto;
    height: auto;
    z-index: 50;
}

nav ul {
    list-style: none;
    padding: 0;
    margin: 0;
    text-align: center;
}

#hamburger {
    position: fixed;
    top: 40px;
    right: 40px;
    width: 78px;
    height: 78px;
    border-radius: 50%;
    background-color: var(--background-alt-color);
    cursor: pointer;
    z-index: 101;
    transition: transform 0.4s ease;
    display: block;
}

#hamburger:hover {
    transform: scale(1.07);
}

#hamburger:hover #hamburger-line-two {
    width: 28px;
}

#hamburger:hover #hamburger-line-one {
    width: 20px;
}

#hamburger-line-one,
#hamburger-line-two {
    position: absolute;
    left: 32%;
    background-color: var(--foreground-alt-color);
    height: 2px;
    border-radius: 2px;
    transition: all 0.4s ease;
    transform-origin: left center;
}

#hamburger-line-one {
    width: 28px;
    top: 44%;
    transform: rotate(0deg);
}

#hamburger-line-two {
    width: 20px;
    top: 55%;
    transform: rotate(0deg);
}

/* Active States for Hamburger */
#hamburger.active {
    background-color: var(--foreground-alt-color);
}
#hamburger.active #hamburger-line-one,
#hamburger.active #hamburger-line-two {
    left: 50%;
    top: 50%;
    width: 28px;
    height: 3px;
    transform-origin: center center;
    background-color: var(--background-alt-color);
}

@media (max-width: 768px) {
    #hamburger {
        width: 64px;
        height: 64px;
        top: 20px;
        right: 20px;
    }
    #hamburger-line-one {
        width: 24px;
        transform: rotate(0deg);
    }
    #hamburger-line-two {
        width: 16px;
        transform: rotate(0deg);
    }
    #hamburger:hover #hamburger-line-two {
        width: 24px;
    }
    #hamburger:hover #hamburger-line-one {
        width: 16px;
    }

    #hamburger.active #hamburger-line-one,
    #hamburger.active #hamburger-line-two {
        left: 50%;
        top: 50%;
        width: 24px;
        height: 3px;
        transform-origin: center center;
        background-color: var(--background-alt-color);
    }
}

#hamburger.active #hamburger-line-one {
    transform: translate(-50%, -50%) rotate(45deg);
}

#hamburger.active #hamburger-line-two {
    transform: translate(-50%, -50%) rotate(-45deg);
}

/* Overlay */
#nav-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: var(--background-alt-color);

    transition: all 0.4s ease-in-out;
    z-index: 100;

    /* Mobile Default: Fade and cover */
    opacity: 0;
    visibility: hidden;
    pointer-events: none;
}

#nav-overlay.active {
    opacity: 1;
    visibility: visible;
    pointer-events: auto;
}

/* Desktop Slide-in Override */
@media (min-width: 769px) {
    #nav-overlay {
        width: 400px;
        left: auto;
        right: 0;
        transform: translateX(100%);
        
        /* Reset mobile fade styles */
        opacity: 1;
        visibility: visible;
        pointer-events: auto; /* Managed by transform */
        
        box-shadow: -5px 0 15px rgba(0,0,0,0.5);
    }
    
    #nav-overlay.active {
        transform: translateX(0);
    }
}

#nav-overlay-container {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

#nav-overlay-container ul :deep(li a) {
    opacity: 1 !important;
    display: block;
    color: var(--foreground-alt-color);
    text-decoration: none;
    text-align: center;
    text-transform: uppercase;
    white-space: nowrap;

    font-family: bebas-kai, sans-serif;
    font-size: 32px;
    line-height: 36px;

    border: 2px solid var(--foreground-alt-color);
    padding: 25px;
    min-width: 60vw;
    border-radius: 45px;

    transition:
        border,
        outline-width 0.3s;
    cursor: pointer;

    outline-width: 0;
    outline-style: solid;
    outline-offset: -1px;

    margin: 30px 0;
}

@media (min-width: 769px) {
    #nav-overlay-container ul :deep(li a) {
        min-width: 250px; /* Reduced width for side panel */
        font-size: 24px;
        padding: 15px;
    }
}

#nav-overlay-container ul :deep(li a:hover) {
    border: 2px solid var(--foreground-alt-color);
    outline-width: 5px;
}

.active-menu-item {
    background-color: white;
    color: black !important;
    border: 2px solid rgba(255, 255, 255, 1) !important;
    outline-width: 0 !important;
    opacity: 1 !important;
}
</style>
