import { Global } from "@emotion/react";

const Fonts = () => (
  <Global
    styles={`
      @font-face {
        font-family: 'PolySans Neutral';
        font-style: normal;
        font-weight: 400;
        font-display: swap;
        src: url('./fonts/PolySans Neutral.ttf') format('ttf');
      }
      @font-face {
        font-family: 'PolySans Median';
        font-style: normal;
        font-weight: 600;
        font-display: swap;
        src: url('./fonts/PolySans Median.ttf') format('ttf');
      }
      `}
  />
);

export default Fonts;
