---
name: QuickBite
colors:
  surface: '#f9f9fc'
  surface-dim: '#dadadc'
  surface-bright: '#f9f9fc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f6'
  surface-container: '#eeeef0'
  surface-container-high: '#e8e8ea'
  surface-container-highest: '#e2e2e5'
  on-surface: '#1a1c1e'
  on-surface-variant: '#594139'
  inverse-surface: '#2f3133'
  inverse-on-surface: '#f0f0f3'
  outline: '#8d7168'
  outline-variant: '#e1bfb5'
  surface-tint: '#ab3500'
  primary: '#ab3500'
  on-primary: '#ffffff'
  primary-container: '#ff6b35'
  on-primary-container: '#5f1900'
  inverse-primary: '#ffb59d'
  secondary: '#845400'
  on-secondary: '#ffffff'
  secondary-container: '#feb246'
  on-secondary-container: '#6f4600'
  tertiary: '#00677e'
  on-tertiary: '#ffffff'
  tertiary-container: '#00a7cb'
  on-tertiary-container: '#003744'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbd0'
  primary-fixed-dim: '#ffb59d'
  on-primary-fixed: '#390c00'
  on-primary-fixed-variant: '#832600'
  secondary-fixed: '#ffddb6'
  secondary-fixed-dim: '#ffb95a'
  on-secondary-fixed: '#2a1800'
  on-secondary-fixed-variant: '#643f00'
  tertiary-fixed: '#b5ebff'
  tertiary-fixed-dim: '#59d5fb'
  on-tertiary-fixed: '#001f28'
  on-tertiary-fixed-variant: '#004e60'
  background: '#f9f9fc'
  on-background: '#1a1c1e'
  surface-variant: '#e2e2e5'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
---

## Brand & Style
The design system focuses on a "Modern Premium" aesthetic tailored for the fast-paced yet high-end campus environment. It bridges the gap between high-utility efficiency and a sophisticated lifestyle brand. The visual language is rooted in **Material 3 (M3)** principles—utilizing tonal surfaces and intentional containment—but elevated through a minimal, high-contrast execution.

The brand personality is **Smart and Friendly**, aiming to reduce the cognitive load of a busy student while providing a "rewarding" visual experience during the ordering process. The aesthetic leans into a "Modern / Corporate" hybrid, utilizing significant whitespace and refined depth to evoke a sense of premium service.

## Colors
The palette is anchored by **Sunset Orange**, a vibrant, high-energy hue that stimulates appetite and signals speed. This is balanced by **Pastel Orange** for secondary actions and a clean, gallery-like **Off-White** background to maintain a premium feel.

- **Primary (#FF6B35):** Used for key call-to-actions, active states, and brand-heavy components.
- **Secondary (#FFB347):** Reserved for accents, promotional chips, and soft highlights.
- **Neutral:** A deep slate-charcoal is used for text to ensure AA/AAA accessibility against the light backgrounds.
- **Surface Strategy:** The system uses a "Container" model. Backgrounds stay light (#F8F9FA), while interactive cards use pure white (#FFFFFF) to create a subtle but clear elevation change without heavy shadows.

## Typography
The system uses **Inter** exclusively to achieve a clean, systematic, and utilitarian look that remains highly legible at small sizes (essential for menu descriptions). 

- **Headlines:** Set with tight letter-spacing and bold weights to create a strong visual anchor for café names and section headers.
- **Body:** Standardized on a 16px base for optimal readability on mobile devices.
- **Labels:** Used for navigation items, button text, and nutritional info. These utilize medium weights to distinguish them from body copy.

## Layout & Spacing
The spacing system is built on a **4px baseline grid**. This ensures mathematical harmony across all components.

- **Mobile Layout:** 4-column fluid grid with 20px outside margins. This provides enough "breathable" space to feel premium.
- **Vertical Rhythm:** Elements are grouped using 8px (related) or 16px (distinct) intervals. Section headers are separated by 32px to create clear content blocks.
- **Touch Targets:** All interactive elements (buttons, chips, list items) maintain a minimum height of 48px to ensure ease of use while walking across campus.

## Elevation & Depth
Depth is communicated through **Tonal Layers** and **Soft Ambient Shadows**. 

- **Surface 0 (Background):** #F8F9FA.
- **Surface 1 (Cards/Inputs):** Pure White (#FFFFFF) with a very soft shadow (0px 4px 20px rgba(0,0,0,0.04)).
- **Glassmorphism:** Navigation bars and sticky headers use a 20px backdrop blur with a 70% opacity white fill. This maintains context of the scrollable content beneath while keeping the UI feeling light.
- **Interactive State:** Upon press, cards should transition from their base shadow to a tighter, deeper shadow to simulate "pressing" into the surface.

## Shapes
The shape language is characterized by **Generous Radii**. This reinforces the "Friendly" brand personality and makes the UI feel approachable.

- **Large Components (Cards, Sheets):** 24px radius. These are the primary containers for Café and Menu items.
- **Standard Components (Buttons):** 16px radius for a modern "squircle" feel.
- **Utility Components (Chips):** Full pill-shape (100px) to distinguish them from actionable buttons.

## Components

### Buttons
- **Primary:** Sunset Orange fill, white text, 16px radius. High emphasis.
- **Secondary:** Pastel Orange 15% opacity fill, Sunset Orange text. Medium emphasis.
- **Social:** Bordered (#E2E8F0) with 16px radius and brand icons. Low emphasis.

### Cards
- **Café Card:** Large 24px radius, full-bleed imagery top, 16px internal padding for text. Uses the Surface 1 shadow.
- **Menu Item:** Horizontal layout for list views. Features a square 12px thumbnail on the leading edge.

### Input Fields
- **Modern Style:** 12px radius, light grey background (#F1F3F5), no border. On focus, transitions to a 2px Sunset Orange stroke.
- **Validation:** Error states use #EF4444 for both the stroke and the micro-copy below the field.

### Navigation
- **Bottom Bar:** 20px backdrop blur, active states indicated by a Sunset Orange pill indicator behind the icon (M3 style).
- **Timeline:** Vertical 2px dashed line in light grey with Primary colored nodes to indicate order progress.

### Chips
- **Categories:** Pill-shaped, light grey fill. When selected, switches to Primary fill with white text.