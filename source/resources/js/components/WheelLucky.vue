<template>
    <div>
       
        <!-- <span>Prize {{ prizeLenght }}  number: {{ prizeNumber }}</span>
    <button
        type="button"
        @click="!rolling && prizeNumber < 8 && prizeNumber++"
        :disabled="rolling || prizeNumber === 8"
    >
        Add
    </button>
    <button
        type="button"
        @click="!rolling && prizeNumber > 2 && prizeNumber--"
        :disabled="rolling || prizeNumber === 2"
    >
        Remove
    </button> -->
    <div class="wheel-wrapper">
        <div class="wheel-pointer" @click="onClickRotate">Start</div>
        <div
            class="wheel-bg"
            :class="{ freeze: freeze }"
            :style="`transform: rotate(${wheelDeg}deg)`"
        >
            <div class="prize-list">
                <div
                    class="prize-item-wrapper"
                    v-for="(item, index) in prizeList"
                    :key="index"
                >
                    <div
                        class="prize-item"
                        :style="`
                        z-index:10;
                        background: ${item.color ?? randomColor()};
                        transform: rotate(${
                            (360 / prizeList.length) * index
                        }deg)`
                        "
                    >
                        <div class="prize-name">
                            {{ item.name}}
                        </div>
                        <div class="prize-icon">
                            <img :src="item.icon"  width="40px" height="40px"/>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
export default {
    name: "WheelLucky",
    data() {
        return {
            freeze: false,
            rolling: false,
            clipath: "polygon(10px 0, 50% 100%, 132px 0)",
            width: '150px',
            wheelDeg: 0,
            prizeNumber: 6,
            prizeListOrigin: [
                {
                    icon: "https://picsum.photos/40?random=1",
                    name: "$10000",
                    color: 'red',
                },
                {
                    icon: "https://picsum.photos/40?random=6",
                    name: "Thank you!",
                    color: 'blue',

                },
                {
                    icon: "https://picsum.photos/40?random=2",
                    name: "$500",
                    color: 'green',

                },
            ],
        };
    },
    computed: {
        prizeList() {
            return this.prizeListOrigin;
        },
        prizeLenght() {
            return this.prizeList.length
        }
    },
    methods: {
        randomColor() {
           return `#${Math.floor(Math.random()*16777215).toString(16)}`;
        },
        onClickRotate() {
            if (this.rolling) {
                return;
            }
            const result = Math.floor(Math.random() * this.prizeList.length);
            this.roll(result);
        },
        roll(result) {
            this.rolling = true;
            const { wheelDeg, prizeList } = this;
            this.wheelDeg =
                wheelDeg -
                (wheelDeg % 360) +
                6 * 360 +
                (360 - (360 / prizeList.length) * result);
            setTimeout(() => {
                this.rolling = false;
                alert("Result：" + prizeList[result].name);
            }, 4500);
        },
        updateLength() {
            let _length = this.prizeLenght;
            console.log(_length,this.clipath)
            if(_length == 8){
                this.clipath = "polygon(10px 0, 50% 100%, 132px 0)";
            }
            else if(_length == 7){
                this.clipath ="polygon(3px 0, 50% 100%, 146px 0)"
            } else if(_length == 6) {
                this.clipath = "polygon(-9px 0, 50% 100%, 163px 0)"
            }
        }
    },
    watch: {
        prizeNumber() {
            this.freeze = true;
            this.wheelDeg = 0;

            setTimeout(() => {
                this.freeze = false;
            }, 0);
        },
        
    },
    created(){
        this.updateLength()
    }
};
</script>

<style>
html {
    background: #dd7c7d;
}

.wheel-wrapper {
    width: 300px;
    height: 300px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

.wheel-pointer {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: yellow;
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
    line-height: 50px;
    z-index: 10;
    cursor: pointer;

    &::after {
        content:  "";
        position: absolute;
        top: -10px;
        left: 50%;
        width: 26px;
        height:26px;
        z-index:5;
        clip-path: polygon(50% 0%, 35% 50%, 66% 50%);
        border-style: solid;
        background: yellow;
        transform: translateX(-50%);
    }
}
.wheel-bg {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    overflow: hidden;
    transition: transform 4s ease-in-out;
    background: #7eef97;

    &.freeze {
        transition: none;
        background: red;
    }
}

.prize-list {
    width: 100%;
    height: 100%;
    position: relative;
    text-align: center;
}

.prize-item-wrapper {
    position: absolute;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 150px;
    height: 150px;
}

.prize-item {
    width: 150px;
    height: 150px;
    transform-origin: bottom;
    -webkit-clip-path: v-bind(clipath);
    clip-path:  v-bind(clipath);
    .prize-name {
        padding: 8px 0;
    }

    .prize-name {
        position: relative;
        width: 150px;
        overflow: hidden;
    }
    .prize-icon {
        position: relative;
        width: 150px;
        overflow: hidden;
    }
}

</style>
