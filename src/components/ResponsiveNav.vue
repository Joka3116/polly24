<template>
    <nav>
        <div
            id="nav-overlay"
            :class="{ active: isMenuOpen }"
            @click="handleOverlayClick"
        >
            <div id="nav-overlay-container">
                <ul>
                    <li>
                        <slot></slot>
                    </li>
                </ul>
                <div class="top-right-header">
                    <router-link to="/">Who wants to be<br>a millionaire?</router-link>
        </div>
            </div>
        </div>
        
        <div id="hamburger" :class="{ active: isMenuOpen }" @click="toggleMenu">
            <span id="hamburger-line-one"></span>
            <span id="hamburger-line-two"></span>
        </div>    
    </nav>
</template>

<script setup>
import { ref, watch } from 'vue';

const isMenuOpen = ref(false);

const toggleMenu = () => {
    isMenuOpen.value = !isMenuOpen.value;
};

const handleOverlayClick = (event) => {
    if (!event.target.closest('.lang-switch-container')) {
        isMenuOpen.value = false;
    }
};

const getScrollbarWidth = () => {
    return window.innerWidth - document.documentElement.clientWidth;
};

watch(isMenuOpen, (isOpen) => {
    if (isOpen) {
        const scrollbarWidth = getScrollbarWidth();
        document.body.style.overflow = 'hidden';
        document.body.style.setProperty('--scrollbar-gap', `${scrollbarWidth}px`);
        document.body.style.paddingRight = `${scrollbarWidth}px`;
    } else {
        document.body.style.overflow = '';
        document.body.style.removeProperty('--scrollbar-gap');
        document.body.style.paddingRight = '';
    }
});
</script>

<style scoped>
.top-right-header {
    position: fixed;
    right: calc(8.75rem + var(--scrollbar-gap, 0px));
    top: 3.875rem;
    text-align: right;
    font-size: 1.2rem;
    font-family: "bebas-kai", sans-serif;
    text-transform: uppercase;
}
.top-right-header :deep(a) {
    color: var(--foreground-alt-color) !important;
    text-decoration: none;
}
.top-right-header :deep(a):hover {
    text-decoration: underline;
}
@media (max-width: 768px) {
    .top-right-header {
        right: calc(6.25rem + var(--scrollbar-gap, 0px));
        top: 2.3125rem; 
        font-size: 1rem;
    }
}
/* =========================================
   Navigation Container
   ========================================= */
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

/* =========================================
   Hamburger Button
   ========================================= */
#hamburger {
    position: fixed;
    /* Use REM for positioning so it respects user base font settings */
    top: 2.5rem; /* was 40px */
    right: calc(2.5rem + var(--scrollbar-gap, 0px)); /* was 40px */

    /* Use REM for sizing the click target */
    width: 4.875rem; /* was 78px */
    height: 4.875rem; /* was 78px */

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

/* =========================================
   Hamburger Lines
   ========================================= */
#hamburger-line-one,
#hamburger-line-two {
    position: absolute;
    left: 32%; /* Percentage keeps it aligned regardless of button size */
    background-color: var(--foreground-alt-color);

    /* Keep PX for height to ensure lines stay sharp and don't blur */
    height: 2px;
    border-radius: 2px;

    transition: all 0.4s ease;
    transform-origin: left center;
}

#hamburger-line-one {
    /* Use % for width so lines grow if you change the button size */
    width: 36%; /* approx 28px relative to 78px */
    top: 44%;
    transform: rotate(0deg);
}

#hamburger-line-two {
    width: 26%; /* approx 20px relative to 78px */
    top: 55%;
    transform: rotate(0deg);
}

/* Hover States: staggering the line lengths */
#hamburger:hover #hamburger-line-two {
    width: 36%; /* Matches line-one width */
}

#hamburger:hover #hamburger-line-one {
    width: 26%; /* Shrinks */
}

/* =========================================
   Active State (The "X")
   ========================================= */
#hamburger.active {
    background-color: var(--foreground-alt-color);
}

#hamburger.active #hamburger-line-one,
#hamburger.active #hamburger-line-two {
    left: 50%;
    top: 50%;

    /* Width logic for the X shape */
    width: 36%;
    height: 3px; /* Slightly thicker for the X is fine in px */

    transform-origin: center center;
    background-color: var(--background-alt-color);
}

#hamburger.active #hamburger-line-one {
    transform: translate(-50%, -50%) rotate(45deg);
}

#hamburger.active #hamburger-line-two {
    transform: translate(-50%, -50%) rotate(-45deg);
}

/* =========================================
   Mobile Breakpoint
   ========================================= */
@media (max-width: 768px) {
    #hamburger {
        /* Scale down using REM */
        width: 4rem; /* was 64px */
        height: 4rem; /* was 64px */
        top: 1.25rem; /* was 20px */
        right: calc(1.25rem + var(--scrollbar-gap, 0px));
    }

    /*
       Since we used percentages (%) for the line widths above,
       we largely don't need to redefine widths here!
       They will automatically scale down with the parent #hamburger.
       However, if you want specific tweaks for mobile:
    */

    #hamburger-line-one {
        width: 37%; /* approx 24px of 64px */
    }
    #hamburger-line-two {
        width: 25%; /* approx 16px of 64px */
    }

    /* Reduce menu item sizes on mobile */
    #nav-overlay-container ul :deep(li a) {
        font-size: 1.8rem !important;
        padding: 0.5em !important;
        margin: 1.5rem !important;
        min-width: 70vw !important;
    }
}

/* =========================================
   Overlay
   ========================================= */
#nav-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;

    /* BEST PRACTICE: Use dvh (Dynamic Viewport Height)
       This prevents the mobile URL bar from hiding the bottom of your menu */
    height: 100vh; /* Fallback */
    height: 100dvh;

    background-color: var(--background-alt-color);
    transition: opacity 0.4s ease-in-out, visibility 0.4s ease-in-out;
    z-index: 100;
    opacity: 0;
    visibility: hidden;
    pointer-events: none;
}

#nav-overlay.active {
    opacity: 1;
    visibility: visible;
    pointer-events: auto;
}

#nav-overlay-container {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

/* =========================================
   Menu Items (The Big Change)
   ========================================= */
#nav-overlay-container ul :deep(li a) {
    opacity: 1 !important;
    display: block;
    color: var(--foreground-alt-color);
    text-decoration: none;
    text-align: center;
    text-transform: uppercase;
    white-space: nowrap;

    font-family: bebas-kai, sans-serif;

    /* 1. Base Size: Use REM */
    font-size: 2.5rem;

    /* 2. Line Height: Use Unitless (multiplies font-size) */
    line-height: 1.2;

    /* 3. Spacing: Use EM so padding/radius scales if font-size grows */
    padding: 0.625em; /* Replaces 25px */
    border-radius: 1.2em; /* Replaces 45px (pill shape) */

    /* 4. Layout Spacing: Use REM for distance between items */
    margin: 2rem 0; /* Replaces 30px */

    /* 5. Width: Viewport Width is good here */
    min-width: 60vw;

    /* 6. Border: Keep PX for crisp lines */
    border: 2px solid var(--foreground-alt-color);

    transition:
        border,
        outline-width 0.3s;
    cursor: pointer;

    outline-width: 0;
    outline-style: solid;
    outline-offset: -1px;
}

#nav-overlay-container ul :deep(li a) {
    opacity: 1;
    display: block;
    color: var(--foreground-alt-color); /* Solid by default */

    /* Layout Properties (Restored) */
    text-decoration: none;
    text-align: center;
    text-transform: uppercase;
    white-space: nowrap;
    font-family: bebas-kai, sans-serif;
    font-size: 2.5rem;
    line-height: 1.2;
    padding: 0.625em;
    border-radius: 1.2em;
    margin: 2rem 0;
    min-width: 60vw;
    border: 2px solid var(--foreground-alt-color);

    /* Add color to transition so it fades smoothly */
    transition:
        color 0.3s ease,
        border 0.3s ease,
        outline-width 0.3s ease;

    cursor: pointer;
    outline-width: 0;
    outline-style: solid;
    outline-offset: -1px;
}

#nav-overlay-container ul :deep(li a:hover) {
    border: 2px solid var(--foreground-alt-color);
    outline-width: 5px;
    outline-color: var(--foreground-alt-color);

    color: color-mix(
        in srgb,
        var(--foreground-alt-color),
        transparent 0%
    ) !important;
}

#nav-overlay-container ul :deep(li a.router-link-exact-active) {
    border: 2px solid var(--foreground-alt-color) !important;

    /* Keep text dimmed */
    color: color-mix(
        in srgb,
        var(--foreground-alt-color),
        transparent 70%
    ) !important;

    pointer-events: none;
    cursor: default;
    background-color: transparent !important;
}

#nav-overlay-container ul :deep(.lang-switch-container) {
    position: absolute;
    bottom: 5vh;
    left: 50%;
    transform: translateX(-50%);
    margin: 0;
}
</style>
