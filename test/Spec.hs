module Main (main) where

import Codec.Picture (Image (..))
import Codec.Picture.Png (encodePng)
import Codec.Picture.WebP
import qualified Data.ByteString as BS
import Test.Tasty
import Test.Tasty.HUnit

main :: IO ()
main = defaultMain $ do
  testGroup
    "All tests"
    [ noExceptionTests,
      sizeTests
    ]

sizeTests :: TestTree
sizeTests =
  testGroup
    "Sizes are as expected"
    [ expectedSize 1012 759 "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      expectedSize 1012 759 "test/data/d99cc366dfbbf99493f917e2d43c683f.webp",
      expectedSizeRoundtrip "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      expectedSizeRoundtrip "test/data/d99cc366dfbbf99493f917e2d43c683f.webp"
    ]

expectedSize :: Int -> Int -> FilePath -> TestTree
expectedSize width height fp =
  testCase ("Converts to PNG (" ++ fp ++ ")") $ do
    bs <- BS.readFile fp
    let img = decodeRgb8 bs
    assertEqual "Expected width" width $ imageWidth img
    assertEqual "Expected height" height $ imageHeight img

expectedSizeRoundtrip :: FilePath -> TestTree
expectedSizeRoundtrip fp =
  testCase ("Converts to PNG (" ++ fp ++ ")") $ do
    bs <- BS.readFile fp
    let img = decodeRgb8 bs
        conv = encodeRgb8 0.4 img
        imgConv = decodeRgb8 conv
    assertEqual "Expected width" (imageWidth img) (imageWidth imgConv)
    assertEqual "Expected height" (imageHeight img) (imageHeight imgConv)

noExceptionTests :: TestTree
noExceptionTests =
  testGroup
    "Converts to PNG without throwing an exception"
    [ convRgbPng "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      convRgbPng "test/data/d99cc366dfbbf99493f917e2d43c683f.webp",
      convRgbaPng "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      convRgbaPng "test/data/d99cc366dfbbf99493f917e2d43c683f.webp",
      roundtripLosslessRGB "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      roundtripLosslessRGB "test/data/d99cc366dfbbf99493f917e2d43c683f.webp",
      roundtripLosslessRGBA "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      roundtripLosslessRGBA "test/data/d99cc366dfbbf99493f917e2d43c683f.webp",
      roundtripRGB "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      roundtripRGB "test/data/d99cc366dfbbf99493f917e2d43c683f.webp",
      roundtripRGBA "test/data/6b3001b4ebfc341ed0359c00586e6ce1.webp",
      roundtripRGBA "test/data/d99cc366dfbbf99493f917e2d43c683f.webp"
    ]

convRgbPng :: FilePath -> TestTree
convRgbPng fp = testCase ("Converts to PNG (" ++ fp ++ ")") $ do
  bs <- BS.readFile fp
  let img = decodeRgb8 bs
      conv = encodePng img
  assertBool "No exception" (conv `seq` True)

convRgbaPng :: FilePath -> TestTree
convRgbaPng fp = testCase ("Converts to PNG (" ++ fp ++ ")") $ do
  bs <- BS.readFile fp
  let img = decodeRgba8 bs
      conv = encodePng img
  assertBool "No exception" (conv `seq` True)

roundtripLosslessRGB :: FilePath -> TestTree
roundtripLosslessRGB fp = testCase ("roundtripLosslesss (" ++ fp ++ ")") $ do
  bs <- BS.readFile fp
  let img = decodeRgb8 bs
      conv = encodeRgb8Lossless img
  assertBool "No exception" (conv `seq` True)

roundtripLosslessRGBA :: FilePath -> TestTree
roundtripLosslessRGBA fp = testCase ("roundtripLosslesss (" ++ fp ++ ")") $ do
  bs <- BS.readFile fp
  let img = decodeRgba8 bs
      conv = encodeRgba8Lossless img
  assertBool "No exception" (conv `seq` True)

roundtripRGB :: FilePath -> TestTree
roundtripRGB fp = testCase ("roundtripLosslesss (" ++ fp ++ ")") $ do
  bs <- BS.readFile fp
  let img = decodeRgb8 bs
      conv = encodeRgb8 0.4 img
  assertBool "No exception" (conv `seq` True)

roundtripRGBA :: FilePath -> TestTree
roundtripRGBA fp = testCase ("roundtripLosslesss (" ++ fp ++ ")") $ do
  bs <- BS.readFile fp
  let img = decodeRgba8 bs
      conv = encodeRgba8 0.4 img
  assertBool "No exception" (conv `seq` True)
